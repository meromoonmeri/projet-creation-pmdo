import json
import os
import sys
from pathlib import Path

# NOTE: The followed code is AI-generated

def find_team_spawn_zones(data):
    """Find all TeamSpawnZoneStep objects following the structure: Object > Segments > [n] > ZoneSteps > [n]"""
    zones = []
    
    # Navigate to Segments
    if "Object" in data and "Segments" in data["Object"]:
        segments = data["Object"]["Segments"]
        
        for segment_idx, segment in enumerate(segments):
            if "ZoneSteps" in segment:
                zone_steps = segment["ZoneSteps"]
                
                for step_idx, step in enumerate(zone_steps):
                    # Check if this is a TeamSpawnZoneStep
                    if isinstance(step, dict) and step.get("$type") == "RogueEssence.LevelGen.TeamSpawnZoneStep, RogueEssence":
                        zones.append({
                            "data": step,
                            "segment_idx": segment_idx,
                            "step_idx": step_idx
                        })
    
    return zones

def extract_monster_data(spawn_zone, segment_name=""):
    """Extract monster data from a TeamSpawnZoneStep."""
    monsters = []
    
    # Process regular Spawns
    if "Spawns" in spawn_zone:
        for spawn_entry in spawn_zone["Spawns"]:
            try:
                spawn_data = spawn_entry.get("Spawn", {}).get("Spawn", {})
                
                # Extract base information
                base_form = spawn_data.get("BaseForm", {})
                species = base_form.get("Species", "unknown")
                
                level_info = spawn_data.get("Level", {})
                min_level = level_info.get("Min", 1)
                max_level = level_info.get("Max", 1)
                
                # Get moves
                moves = spawn_data.get("SpecifiedSkills", [])
                
                # Get ability/intrinsic
                intrinsic = spawn_data.get("Intrinsic", "")
                
                # Get floor range
                # Min is 0-based, Max is exclusive (unless Min == Max)
                range_info = spawn_entry.get("Range", {})
                start_floor = range_info.get("Min", 0)
                max_floor = range_info.get("Max", 0)
                
                # If Min == Max, it's a single floor, otherwise Max is exclusive
                if start_floor == max_floor:
                    end_floor = start_floor
                else:
                    end_floor = max_floor - 1
                
                monster = {
                    "species": species,
                    "min_level": min_level,
                    "max_level": max_level,
                    "moves": moves,
                    "intrinsic": intrinsic,
                    "start_floor": start_floor,
                    "end_floor": end_floor,
                    "segment": segment_name,
                    "segment_idx": int(segment_name.split()[1].rstrip(',')) if segment_name else 0,
                    "spawn_type": "regular"
                }
                
                monsters.append(monster)
            
            except Exception as e:
                print(f"Error extracting monster data from Spawns: {e}")
                continue
    
    # Process SpecificSpawns
    if "SpecificSpawns" in spawn_zone:
        for specific_idx, specific_entry in enumerate(spawn_zone["SpecificSpawns"]):
            try:
                spawn_group = specific_entry.get("Spawn", {})
                spawns_list = spawn_group.get("Spawns", [])
                
                # Get floor range for this specific spawn group
                range_info = specific_entry.get("Range", {})
                start_floor = range_info.get("Min", 0)
                max_floor = range_info.get("Max", 0)
                
                if start_floor == max_floor:
                    end_floor = start_floor
                else:
                    end_floor = max_floor - 1
                
                # Process each spawn in the group
                for spawn_data in spawns_list:
                    base_form = spawn_data.get("BaseForm", {})
                    species = base_form.get("Species", "unknown")
                    
                    level_info = spawn_data.get("Level", {})
                    min_level = level_info.get("Min", 1)
                    max_level = level_info.get("Max", 1)
                    
                    moves = spawn_data.get("SpecifiedSkills", [])
                    intrinsic = spawn_data.get("Intrinsic", "")
                    
                    monster = {
                        "species": species,
                        "min_level": min_level,
                        "max_level": max_level,
                        "moves": moves,
                        "intrinsic": intrinsic,
                        "start_floor": start_floor,
                        "end_floor": end_floor,
                        "segment": segment_name,
                        "segment_idx": int(segment_name.split()[1].rstrip(',')) if segment_name else 0,
                        "spawn_type": "specific",
                        "specific_group": specific_idx
                    }
                    
                    monsters.append(monster)
            
            except Exception as e:
                print(f"Error extracting monster data from SpecificSpawns: {e}")
                continue
    
    return monsters

def format_wiki_table(monsters, filename):
    """Format monsters data into wiki table format, grouped by segment and spawn type."""
    # Group monsters by segment, spawn type, and specific group
    from collections import defaultdict
    segments = defaultdict(lambda: {"regular": [], "specific": defaultdict(list)})
    
    for monster in monsters:
        segment_idx = monster.get("segment_idx", 0)
        spawn_type = monster.get("spawn_type", "regular")
        
        if spawn_type == "specific":
            specific_group = monster.get("specific_group", 0)
            segments[segment_idx]["specific"][specific_group].append(monster)
        else:
            segments[segment_idx]["regular"].append(monster)
    
    output = []
    
    # Create tables for each segment
    for segment_idx in sorted(segments.keys()):
        segment_data = segments[segment_idx]
        
        # Add segment header if there are multiple segments
        if len(segments) > 1:
            output.append(f"=== Segment {segment_idx} ===")
        
        # Regular spawns table
        if segment_data["regular"]:
            sorted_monsters = sorted(segment_data["regular"], key=lambda m: (m["start_floor"], m["species"]))
            output.extend(create_encounter_table(sorted_monsters, "Regular Encounters" if segment_data["specific"] else None))
        
        # Specific spawns tables (one per group)
        if segment_data["specific"]:
            for group_idx in sorted(segment_data["specific"].keys()):
                group_monsters = segment_data["specific"][group_idx]
                sorted_monsters = sorted(group_monsters, key=lambda m: (m["start_floor"], m["species"]))
                output.extend(create_encounter_table(sorted_monsters, f"Specific Spawn Group {group_idx + 1}"))
        
        output.append("")  # Empty line between segments
    
    return "\n".join(output)


def create_encounter_table(monsters, table_title=None):
    """Create a single encounter table."""
    output = []
    
    if table_title:
        output.append(f"==== {table_title} ====")
    
    output.append("{| class=\"wikitable\"")
    output.append("{{EncounterHeader}}")
    
    for monster in monsters:
        # Handle level display
        min_level = monster["min_level"]
        max_level = monster["max_level"]
        
        if min_level == max_level:
            level = str(min_level)
        else:
            actual_max = max_level - 1
            if min_level == actual_max:
                level = str(min_level)
            else:
                level = f"{min_level}-{actual_max}"
        
        # Format moves (capitalize each word, replace underscores)
        formatted_moves = [move.replace("_", " ").title() for move in monster["moves"]]
        moves_str = ", ".join(formatted_moves) if formatted_moves else ""
        
        # Format ability/intrinsic (capitalize and replace underscores)
        ability = monster["intrinsic"].replace("_", " ").title() if monster["intrinsic"] else ""
        
        # Capitalize species name
        pokemon_name = monster["species"].replace("_", " ").title()
        
        # Add 1 to floors for display (convert from 0-indexed to 1-indexed)
        display_start = monster['start_floor'] + 1
        display_end = monster['end_floor'] + 1
        
        output.append("{{EncounterRow")
        output.append(f"|pokemon={pokemon_name}")
        output.append(f"|level={level}")
        output.append(f"|start_floor={display_start}")
        output.append(f"|end_floor={display_end}")
        output.append(f"|ability={ability}")
        output.append(f"|moves={moves_str}")
        output.append("}}")
    
    output.append("|}")
    output.append("<br clear=all>")
    
    return output

def process_json_file(json_path, output_dir=None):
    """Main function to process a single JSON file."""
    try:
        # Read JSON file (handle UTF-8 BOM)
        with open(json_path, 'r', encoding='utf-8-sig') as f:
            data = json.load(f)
        
        print(f"\nProcessing: {json_path}")
        
        # Find all TeamSpawnZoneStep sections
        spawn_zones = find_team_spawn_zones(data)
        print(f"Found {len(spawn_zones)} TeamSpawnZoneStep section(s)")
        
        if len(spawn_zones) == 0:
            print("  No spawn zones found, skipping file.")
            return
        
        all_monsters = []
        
        # Process each zone
        for zone_info in spawn_zones:
            zone = zone_info["data"]
            segment_idx = zone_info["segment_idx"]
            step_idx = zone_info["step_idx"]
            
            segment_name = f"Segment {segment_idx}, ZoneStep {step_idx}"
            monsters = extract_monster_data(zone, segment_name)
            
            print(f"\n{segment_name}:")
            for monster in monsters:
                print(f"  - {monster['species']} (Lv {monster['min_level']}-{monster['max_level']}) "
                      f"Floors {monster['start_floor']}-{monster['end_floor']}")
            
            all_monsters.extend(monsters)
        
        # Generate output filename
        base_name = os.path.splitext(os.path.basename(json_path))[0]
        
        # Determine output path
        if output_dir:
            os.makedirs(output_dir, exist_ok=True)
            output_path = os.path.join(output_dir, f"{base_name}_encounters.txt")
        else:
            output_path = f"{base_name}_encounters.txt"
        
        # Write output file
        wiki_content = format_wiki_table(all_monsters, base_name)
        with open(output_path, 'w', encoding='utf-8') as f:
            f.write(wiki_content)
        
        print(f"\n✓ Output written to: {output_path}")
        print(f"Total monsters found: {len(all_monsters)}")
        
    except FileNotFoundError:
        print(f"Error: File '{json_path}' not found.")
    except json.JSONDecodeError as e:
        print(f"Error: Invalid JSON format - {e}")
    except Exception as e:
        print(f"Error processing file: {e}")


def process_multiple_files(input_path, output_dir="output"):
    """Process multiple JSON files from a directory or list."""
    json_files = []
    
    # Check if input_path is a directory
    if os.path.isdir(input_path):
        print(f"Searching for JSON files in directory: {input_path}")
        for file in os.listdir(input_path):
            if file.endswith('.json'):
                json_files.append(os.path.join(input_path, file))
    
    # Check if input_path is a single file
    elif os.path.isfile(input_path) and input_path.endswith('.json'):
        json_files.append(input_path)
    
    else:
        print(f"Error: '{input_path}' is not a valid file or directory.")
        return
    
    if not json_files:
        print("No JSON files found.")
        return
    
    print(f"Found {len(json_files)} JSON file(s) to process.")
    print(f"Output directory: {output_dir}\n")
    print("=" * 60)
    
    # Process each file
    for json_file in json_files:
        process_json_file(json_file, output_dir)
        print("=" * 60)
    
    print(f"\n✓ All files processed. Check the '{output_dir}' directory for results.")


if __name__ == "__main__":
    # You can specify input as:
    # 1. A single JSON file: "input.json"
    # 2. A directory containing JSON files: "json_files/"
    # 3. Command line arguments: python script.py <input_path> [output_dir]
    
    if len(sys.argv) > 1:
        # Use command line arguments
        input_path = sys.argv[1]
        output_dir = sys.argv[2] if len(sys.argv) > 2 else "output"
        process_multiple_files(input_path, output_dir)
    else:
        # Default: process current directory or specify here
        input_path = "."  # Change this to your input file or directory
        output_dir = "output"  # Change this to your desired output directory
        
        print("Usage: python monster_parser.py <input_file_or_directory> [output_directory]")
        print(f"\nUsing defaults:")
        print(f"  Input: {input_path}")
        print(f"  Output: {output_dir}")
        print()
        
        process_multiple_files(input_path, output_dir)