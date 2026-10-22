import os
import subprocess
from dataclasses import dataclass
from typing import Optional
from mutagen.oggvorbis import OggVorbis

@dataclass
class OggTrack:
    url: str
    title: str
    artist: str
    album: str
    loop_start: Optional[int] = None
    loop_length: Optional[int] = None
    spoiler: Optional[str] = None
    relative: Optional[str] = None


def write_tags(file_path, track: OggTrack):
    audio = OggVorbis(file_path)
    audio["TITLE"] = track.title
    audio["ARTIST"] = track.artist
    audio["ALBUM"] = track.album

    # Optional loop-related tags
    if track.loop_start is not None:
        audio["LOOPSTART"] = str(track.loop_start)
    if track.loop_length is not None:
        audio["LOOPLENGTH"] = str(track.loop_length)

    # Optional flags or custom tags
    if track.spoiler:
        audio["SPOILER"] = track.spoiler
    if track.relative:
        audio["RELATIVE"] = track.relative

    audio.save()


def download_youtube_audio(track: OggTrack, output_dir="./output"):
    try:
        cmd_download = [
            "yt-dlp",
            "-f", "bestaudio",
            "-o", os.path.join(output_dir, "%(title)s.%(ext)s"),
            track.url
        ]
        subprocess.run(cmd_download, check=True)

        files = [f for f in os.listdir(output_dir) if f.endswith((".m4a", ".webm"))]
        latest_file = max(
            [os.path.join(output_dir, f) for f in files],
            key=os.path.getctime,
        )

        # base, _ = os.path.splitext(latest_file)
        output_file = os.path.join(output_dir, f"{track.title}.ogg")

        cmd_convert = [
            "ffmpeg", "-y",
            "-i", latest_file,
            "-codec:a", "libvorbis",
            "-qscale:a", "5",
            output_file
        ]
        subprocess.run(cmd_convert, stdout=subprocess.DEVNULL, stderr=subprocess.STDOUT)
        os.remove(latest_file)

        write_tags(output_file, track)
        print(f"Saved: {output_file}")
    except Exception as e:
        print(f"Error processing {track.url}: {e}")


def batch_download(tracks, output_dir="./output"):
    os.makedirs(output_dir, exist_ok=True)
    for track in tracks:
        download_youtube_audio(track, output_dir)


if __name__ == "__main__":
    TRACKS = [
        # OggTrack(
        #     url="https://www.youtube.com/watch?v=nnO_FFiZJCc",
        #     title="Rock Slide Canyon",
        #     artist="Danirbu",
        #     album="Original Soundtrack",
        #     loop_start=5469672,
        #     loop_length=5476165,
        # ),
        # OggTrack(
        #     url="https://www.youtube.com/watch?v=3ZUDRLMY4_8",
        #     title="Dusty Trails",
        #     artist="Danirbu",
        #     album="Original Soundtrack",
        #     loop_start=5197794,
        #     loop_length=5200320,
        # ),
        # OggTrack(
        #     url="https://www.youtube.com/watch?v=_PVzJOcYZKk",
        #     title="Ruins of Life",
        #     artist="Danirbu",
        #     album="Original Soundtrack",
        #     loop_start=5469672,
        #     loop_length=5476165,
        # ),
        # OggTrack(
        #     url="https://www.youtube.com/watch?v=npTdjMtlHM8&list=LL",
        #     title="Terminal Velocity (Act 1)",
        #     artist="Yash",
        #     album="Sonic Colors",
        #     loop_start=532745,
        #     loop_length=5794417,
        # ),
  
        # OggTrack(
        #     url="https://www.youtube.com/watch?v=14_CoQWjV8I",
        #     title="Vast Poni Canyon",
        #     artist="Yash",
        #     album="Pokemon Sun and Moon",
        #     loop_start=3661194,
        #     loop_length=3071461,
        # ),

        # OggTrack(
        #     url="https://www.youtube.com/watch?v=jO4uMerMpdw",
        #     title="Choral Chambers",
        #     artist="Yash",
        #     album="Silksong",
        #     loop_start=7600216,
        #     loop_length=7587828,
        # ),
        # OggTrack(
        #     url="https://www.youtube.com/watch?v=BuBXcdIqQ4g",
        #     title="Obsidian Fieldlands 2",
        #     artist="FiveNineSquared",
        #     album="Pokemon Legends Arceus",
        #     loop_start=3900211,
        #     loop_length=7740451-3900211,
        # ),

        # OggTrack(
        #     url="https://www.youtube.com/watch?v=N7z_EGZm7jY",
        #     title="Resolution Gorge",
        #     artist="Danirbu",
        #     album="Original Soundtrack",
        #     loop_start=5070965,
        #     loop_length=9669934-5070965,
        # ),     

        # OggTrack(
        #     url="https://www.youtube.com/watch?v=RggYAl27CVo",
        #     title="Green Path",
        #     artist="Yash",
        #     album="Hollow Knight",
        #     loop_start=0,
        #     loop_length=9669790-0,
        # ), 
        
        # OggTrack(
        #     url="https://www.youtube.com/watch?v=NBFWOEwlcBA",
        #     title="The Wind is Blowing at Cavi Cape",
        #     artist="Yash",
        #     album="Mario and Luigi: Bowser's Inside Story ",
        #     loop_start=3158390,
        #     loop_length=6299179-3158390,
        # ), 

        # OggTrack(
        #     url="https://www.youtube.com/watch?v=v--v4WnH3I0",
        #     title="Striking Boss Battle!",
        #     artist="Danirbu",
        #     album="Original Soundtrack",
        #     loop_start=3158390,
        #     loop_length=6299179-3158390,
        # ), 

        # OggTrack(
        #     url="https://www.youtube.com/watch?v=PcKcNRjif-Q",
        #     title="The Dreadful Fight!",
        #     artist="Yash",
        #     album="Final Fantasy IV",
        #     loop_start=1677591,
        #     loop_length=5715667 - 1677591,
        # ), 

        # OggTrack(
        #     url="https://www.youtube.com/watch?v=hdZy_B2LzFw",
        #     title="Battle! Gladion",
        #     artist="Yash",
        #     album="Pokemon Sun and Moon",
        #     loop_start=4165009,
        #     loop_length=7605466-4165009,
        # ),

        OggTrack(
            url="https://www.youtube.com/watch?v=qugtXLaHdGg",
            title="Raise Up Your Bat",
            artist="Josha~",
            album="Deltrune",
            loop_start=4165009,
            loop_length=7605466-4165009,
        ),




        # https://www.youtube.com/watch?v=Yz0XV1bm8Yg"
# Hollow Bastion (Kingdom Hearts)
# https://www.youtube.com/watch?v=RYICv_2sdZw



  
    
    
  

  
    
    
    
  

  
    
    
  

  
    
    
    
  

  
    
      
      
    
    
      
      
    
  
# Battle! AI Professor - PMD2 Soundfont Remix 
# https://www.youtube.com/watch?v=2It76g47tJA

# Gladion Team's
# https://www.youtube.com/watch?v=Yz0XV1bm8Yg



# https://www.youtube.com/watch?v=Yz0XV1bm8Yg


    ]

    batch_download(TRACKS)
