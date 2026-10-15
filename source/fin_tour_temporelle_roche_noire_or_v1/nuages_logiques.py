"""Logical cloud layer separation and disposition-aware 1:1 cloud animation for ETT1 and FTT1."""
import numpy as np
from PIL import Image
from scipy import ndimage as nd

W, H = 768, 576


def make_ett1_layers(decor, mag_im, sol_base, anim_phases=16):
    """ETT1: Central black-obsidian & gold bridge in front of 1:1 horizontally gliding abyssal cloud bands."""
    r_m, g_m, b_m = mag_im[:,:,0].astype(int), mag_im[:,:,1].astype(int), mag_im[:,:,2].astype(int)
    r_d, g_d, b_d = decor[:,:,0].astype(int), decor[:,:,1].astype(int), decor[:,:,2].astype(int)
    yy, xx = np.mgrid[:H, :W]

    is_mag = (r_m > 195) & (b_m > 195) & (g_m < 95) & (np.abs(r_m - b_m) < 55)
    walk_floor = nd.binary_erosion(is_mag, iterations=1) | ((xx >= 328) & (xx <= 440) & (yy >= 140) & (yy <= 576))
    lab_w, _ = nd.label(walk_floor)
    bot_labs = [v for v in np.unique(lab_w[H-8:, :]) if v != 0]
    walk_zone = nd.binary_closing(np.isin(lab_w, bot_labs), iterations=1)

    # Separate central black-obsidian cliff & golden bridge from midnight-blue sky & horizontal clouds
    sky_bg = (r_d <= 10) & (g_d <= 16) & (b_d >= 24) & (b_d <= 38)
    non_sky = ~sky_bg
    is_gold_rim = (r_d > 80) & (r_d - b_d > 25) & (xx >= 145) & (xx <= 622)
    cut_mask = non_sky.copy()
    cut_mask[:250, :155] &= is_gold_rim[:250, :155]
    cut_mask[:250, 613:] &= is_gold_rim[:250, 613:]
    cut_mask[385:465, :172] &= is_gold_rim[385:465, :172]
    cut_mask[385:465, 596:] &= is_gold_rim[385:465, 596:]
    lab_s, _ = nd.label(cut_mask)
    center_lab = lab_s[H//2, W//2]
    central_struct = nd.binary_fill_holes(lab_s == center_lab) | walk_zone
    sky_zone = ~central_struct

    # Dilate central_struct by 4 px before building cloud_canvas so NO golden rim fringe pixel ever enters cloud_canvas!
    sky_col = np.array([5, 11, 32], dtype=np.uint8)
    struct_dil = nd.binary_dilation(central_struct, iterations=4)
    cloud_canvas = decor.copy()
    cloud_canvas[struct_dil] = sky_col
    for y in range(45, 550):
        xs_struct = np.nonzero(struct_dil[y])[0]
        if len(xs_struct) > 0:
            xl, xr = int(xs_struct[0]), int(xs_struct[-1])
            if xl >= 8:
                for k in range(1, min(26, W - xl)):
                    cloud_canvas[y, xl + k - 1] = cloud_canvas[y, max(0, xl - k)]
            if xr < W - 8:
                for k in range(1, min(26, xr)):
                    cloud_canvas[y, xr - k + 1] = cloud_canvas[y, min(W - 1, xr + k)]

    # 00_sol: midnight-blue sky in sky_zone + walkable floor in walk_zone
    sol_rgb = sol_base.copy()
    sol_rgb[sky_zone] = sky_col
    sol_rgb[walk_zone] = decor[walk_zone]
    sol_rgba = np.dstack([sol_rgb, np.full((H, W), 255, dtype=np.uint8)])

    # 01_relief and 02_couronnes: strictly the central black-obsidian cliff & golden portal arch
    detail_mask = (yy < 184) & central_struct & (~walk_zone)
    relief_mask = central_struct & (~walk_zone) & (~detail_mask)

    relief_rgba = np.zeros((H, W, 4), dtype=np.uint8)
    relief_rgba[relief_mask, :3] = decor[relief_mask]
    relief_rgba[relief_mask, 3] = 255

    couronnes_rgba = np.zeros((H, W, 4), dtype=np.uint8)
    couronnes_rgba[detail_mask, :3] = decor[detail_mask]
    couronnes_rgba[detail_mask, 3] = 255

    # Altitude-based parallax parameters for the 5 horizontal cloud strata (1:1 pixel scale!)
    # Upper large band (y < 170): largest horizontal glide (12 px)
    # Upper-mid band (170..266): 9 px horizontal glide, phase +1.1
    # Mid band (266..360): 7 px horizontal glide, phase +2.2
    # Lower-mid band (360..470): 10 px horizontal glide, phase +3.3
    # Bottom band (>= 470): 7 px horizontal glide, phase +4.4
    amp_x = np.where(yy < 170, 12.0, np.where(yy < 266, 9.0, np.where(yy < 360, 7.0, np.where(yy < 470, 10.0, 7.0))))
    amp_y = np.where(yy < 170, 2.0, np.where(yy < 360, 1.5, 1.5))
    band_phi = np.where(yy < 170, 0.0, np.where(yy < 266, 1.1, np.where(yy < 360, 2.2, np.where(yy < 470, 3.3, 4.4))))

    gold_trim = central_struct & (~walk_zone) & (r_d > 175) & (g_d > 135) & (b_d < 90) & (r_d - b_d > 80) & ((xx + yy) % 9 == 0)

    anim_frames = []
    for f in range(anim_phases):
        fr = np.zeros((H, W, 4), dtype=np.uint8)
        theta = 2.0 * np.pi * f / anim_phases

        # Horizontal traveling wave along each horizontal cloud band (1:1 scale, zero stretching!)
        dx = amp_x * np.sin(theta - xx / 110.0 + band_phi)
        dy = amp_y * np.cos(theta - xx / 95.0 + band_phi)

        src_x = np.clip(np.round(xx - dx).astype(int), 0, W - 1)
        src_y = np.clip(np.round(yy - dy).astype(int), 0, H - 1)

        c_sampled = cloud_canvas[src_y, src_x]
        is_cloud_px = (c_sampled[:,:,0] > 10) | (c_sampled[:,:,1] > 16) | (c_sampled[:,:,2] > 38)
        vis_cloud = sky_zone & is_cloud_px
        fr[vis_cloud, :3] = c_sampled[vis_cloud]
        fr[vis_cloud, 3] = 255

        # Subtle golden sheen on clockwork trim
        wave = np.sin(theta - yy * 0.08)[gold_trim]
        fr[gold_trim, 0] = np.clip(r_d[gold_trim] + wave * 14.0, 0, 255).astype(np.uint8)
        fr[gold_trim, 1] = np.clip(g_d[gold_trim] + wave * 12.0, 0, 255).astype(np.uint8)
        fr[gold_trim, 2] = np.clip(b_d[gold_trim] + wave * 6.0, 0, 255).astype(np.uint8)
        fr[gold_trim, 3] = 255

        anim_frames.append(fr)

    return {
        "sol": sol_rgba,
        "relief": relief_rgba,
        "couronnes": couronnes_rgba,
        "anim": anim_frames,
        "walk_zone": walk_zone,
        "relief_mask": relief_mask,
        "couronnes_mask": detail_mask,
    }


def make_ftt1_layers(decor, mag_im, sol_base, anim_phases=16):
    """FTT1: Octagonal black-obsidian & gold summit surrounded by an amphitheater of golden clouds
    that flow and billow logically along their contour around the peak + upper sky horizontal drift."""
    r_m, g_m, b_m = mag_im[:,:,0].astype(int), mag_im[:,:,1].astype(int), mag_im[:,:,2].astype(int)
    r_d, g_d, b_d = decor[:,:,0].astype(int), decor[:,:,1].astype(int), decor[:,:,2].astype(int)
    yy, xx = np.mgrid[:H, :W]

    is_mag = (r_m > 195) & (b_m > 195) & (g_m < 95) & (np.abs(r_m - b_m) < 55)
    walk_floor = nd.binary_erosion(is_mag, iterations=1) | ((xx >= 352) & (xx <= 416) & (yy >= 380) & (yy <= 576))
    lab_w, _ = nd.label(walk_floor)
    bot_labs = [v for v in np.unique(lab_w[H-8:, :]) if v != 0]
    walk_zone = nd.binary_closing(np.isin(lab_w, bot_labs), iterations=1)

    # Separate outer golden cloud sea (`outer_clouds`) from the octagonal black-obsidian crags & platform (`struct_ftt`)
    is_warm = (r_d > 95) & (r_d - b_d > 38)
    lab_f, _ = nd.label(is_warm)
    border_labs = set(np.unique(np.r_[lab_f[0, :], lab_f[-1, :], lab_f[:, 0], lab_f[:, -1]])) - {0}
    outer_clouds = np.isin(lab_f, list(border_labs))
    struct_ftt = nd.binary_fill_holes(~outer_clouds) | walk_zone
    outer_clouds = ~struct_ftt

    # Dilate struct_ftt by 4 px before propagating cloud colors inward so NO dark cliff edge pixel ever enters cloud_canvas!
    struct_dil = nd.binary_dilation(struct_ftt, iterations=4)
    _, (iy, ix) = nd.distance_transform_edt(struct_dil, return_indices=True)
    cloud_canvas = decor.copy()
    cloud_canvas[struct_dil] = decor[iy[struct_dil], ix[struct_dil]]

    # 00_sol: golden cloud base in outer_clouds + walkable black-obsidian floor in walk_zone
    sol_rgb = sol_base.copy()
    sol_rgb[outer_clouds] = cloud_canvas[outer_clouds]
    sol_rgb[walk_zone] = decor[walk_zone]
    sol_rgba = np.dstack([sol_rgb, np.full((H, W), 255, dtype=np.uint8)])

    # 01_relief and 02_couronnes: strictly the black-obsidian crags, octagonal rim, pillars, and southern stairs
    detail_mask = (yy < 168) & struct_ftt & (~walk_zone)
    relief_mask = struct_ftt & (~walk_zone) & (~detail_mask)

    relief_rgba = np.zeros((H, W, 4), dtype=np.uint8)
    relief_rgba[relief_mask, :3] = decor[relief_mask]
    relief_rgba[relief_mask, 3] = 255

    couronnes_rgba = np.zeros((H, W, 4), dtype=np.uint8)
    couronnes_rgba[detail_mask, :3] = decor[detail_mask]
    couronnes_rgba[detail_mask, 3] = 255

    # Compute local contour tangent (tx, ty) and normal (nx, ny) around the octagonal peak
    d_raw = nd.distance_transform_edt(outer_clouds).astype(np.float32)
    d_smooth = nd.gaussian_filter(d_raw, sigma=16.0)
    gy, gx = np.gradient(d_smooth)
    norm = np.hypot(gx, gy) + 1e-6
    nx, ny = gx / norm, gy / norm  # outward normal perpendicular to cloud bank ridges

    # Tangent along the cloud bank ridges (flowing from bottom flanks upward around the octagonal peak)
    side_sign = np.tanh((xx - 384.0) / 36.0)
    tx = side_sign * ny
    ty = -side_sign * nx

    # Arc coordinate along the mountain flank
    s_arc = (H - yy) / 68.0 + np.abs(xx - 384.0) / 110.0

    # Smooth depth modulation so neighbouring cloud pixels move coherently without tearing
    lum = nd.gaussian_filter(0.299 * cloud_canvas[:,:,0] + 0.587 * cloud_canvas[:,:,1] + 0.114 * cloud_canvas[:,:,2], sigma=6.0)
    amp_t = 4.0 + 5.0 * np.clip((lum - 130.0) / 95.0, 0.0, 1.0)
    amp_n = 2.0 + 3.0 * np.clip((lum - 130.0) / 95.0, 0.0, 1.0)
    phase_stratum = 1.4 * (1.0 - np.clip((lum - 130.0) / 95.0, 0.0, 1.0))

    # Upper sky horizontal cloud strata (y < 96, 210 <= x <= 558): blend smoothly into horizontal drift
    top_sky_w = np.clip((104.0 - yy) / 32.0, 0.0, 1.0) * np.clip(1.0 - np.abs(xx - 384.0) / 195.0, 0.0, 1.0)

    gold_trim = struct_ftt & (~walk_zone) & (r_d > 165) & (g_d > 125) & (b_d < 85) & (r_d - b_d > 75) & ((xx + yy) % 9 == 0)

    anim_frames = []
    for f in range(anim_phases):
        fr = np.zeros((H, W, 4), dtype=np.uint8)
        theta = 2.0 * np.pi * f / anim_phases

        wave_t = np.sin(theta - s_arc + phase_stratum)
        wave_n = np.cos(theta - s_arc + phase_stratum)

        dx_ring = amp_t * wave_t * tx + amp_n * wave_n * nx
        dy_ring = amp_t * wave_t * ty + amp_n * wave_n * ny

        dx_top = 10.0 * np.sin(theta - xx / 64.0 + yy / 42.0)
        dy_top = 2.0 * np.cos(theta - xx / 64.0)

        dx = (1.0 - top_sky_w) * dx_ring + top_sky_w * dx_top
        dy = (1.0 - top_sky_w) * dy_ring + top_sky_w * dy_top

        src_x = np.clip(np.round(xx - dx).astype(int), 0, W - 1)
        src_y = np.clip(np.round(yy - dy).astype(int), 0, H - 1)

        fr[outer_clouds, :3] = cloud_canvas[src_y[outer_clouds], src_x[outer_clouds]]
        fr[outer_clouds, 3] = 255

        # Subtle golden sheen on octagonal border trim only
        g_wave = np.sin(theta - yy * 0.08)[gold_trim]
        fr[gold_trim, 0] = np.clip(r_d[gold_trim] + g_wave * 12.0, 0, 255).astype(np.uint8)
        fr[gold_trim, 1] = np.clip(g_d[gold_trim] + g_wave * 10.0, 0, 255).astype(np.uint8)
        fr[gold_trim, 2] = np.clip(b_d[gold_trim] + g_wave * 5.0, 0, 255).astype(np.uint8)
        fr[gold_trim, 3] = 255

        anim_frames.append(fr)

    return {
        "sol": sol_rgba,
        "relief": relief_rgba,
        "couronnes": couronnes_rgba,
        "anim": anim_frames,
        "walk_zone": walk_zone,
        "relief_mask": relief_mask,
        "couronnes_mask": detail_mask,
    }
