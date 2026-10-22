CONFIG = {}

function CONFIG.InitializeAll()
SV.Settings = {
    Starters = 0,
    Nicknames = 0
}
end

function CONFIG.Initialize(config)
    SV.Settings = SV.Settings or {}
    SV.Settings[config] = SV.Settings[config] or 0
end

function CONFIG.UseNicknames()
    CONFIG.Initialize("Nicknames")
    return SV.Settings.Nicknames == 0
end

function CONFIG.RegularStarters()
    CONFIG.Initialize("Starters")
    return SV.Settings.Starters == 0
end