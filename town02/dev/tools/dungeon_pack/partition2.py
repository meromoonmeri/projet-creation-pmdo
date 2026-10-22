import os
import sys
import json

# Define checkpoints
CHECKPOINTS = [
    {"min": 10, "max": 15},
    {"min": 15, "max": 20},
    {"min": 20, "max": 25},
    {"min": 25, "max": 30},
    {"min": 30, "max": 35},
    {"min": 35, "max": 40},
    {"min": 40, "max": 45},
    {"min": 45, "max": 50},
    {"min": 50, "max": 55},
    {"min": 55, "max": 60},
    {"min": 60, "max": 65},
    {"min": 65, "max": 70},
]

def load_all_monsters(monster_dir):
    """Load all monster data into a dict keyed by monster name"""
    monsters = {}
    
    for filename in os.listdir(monster_dir):
        if not filename.lower().endswith(".json"):
            continue
        
        path = os.path.join(monster_dir, filename)
        try:
            with open(path, "r", encoding="utf-8-sig") as f:
                data = json.load(f)
        except Exception as e:
            print(f"Skipping {filename}: {e}", file=sys.stderr)
            continue
        
        obj = data.get("Object", {})
        
        # Skip unreleased monsters
        if not obj.get("Released", True):
            continue
        
        monster_name = obj.get("Name", {}).get("DefaultText", "").lower()
        if monster_name:
            monsters[monster_name] = obj
    
    return monsters

def get_evolution_level(obj):
    """Get the evolution level from a monster's promotions"""
    promotions = obj.get("Promotions", [])
    
    for promo in promotions:
        details = promo.get("Details", [])
        for detail in details:
            detail_type = detail.get("$type", "")
            if detail_type == "PMDC.Data.EvoLevel, PMDC":
                return detail.get("Level")
            elif detail_type == "PMDC.Data.EvoItem, PMDC":
                return "item"
    
    return None

def partition_by_checkpoints(monsters):
    """
    Partitions monsters based on checkpoints.
    Base forms appear in checkpoints before their evolution level.
    Evolved forms appear in the checkpoint AFTER their evolution level and ALL subsequent checkpoints.
    """
    # Create partitions for each checkpoint
    partitions = {}
    for i, checkpoint in enumerate(CHECKPOINTS):
        key = f"{checkpoint['min']}-{checkpoint['max']}"
        partitions[key] = {}
    
    partitions["item_evo"] = {}
    partitions["can_evolve"] = {}
    partitions["none"] = {}
    
    # Initialize type lists
    types = ["normal", "fire", "water", "grass", "electric", "ice", "fighting", 
             "poison", "ground", "flying", "psychic", "bug", "rock", "ghost", 
             "dragon", "dark", "steel", "fairy"]
    
    for partition in partitions.values():
        for type_name in types:
            partition[type_name] = []
    
    # Build evolution chain map
    evolution_chains = {}  # Maps each pokemon to its full evolution data
    
    for monster_name, obj in monsters.items():
        evo_level = get_evolution_level(obj)
        evolution_chains[monster_name] = {
            "obj": obj,
            "evo_level": evo_level,
            "result": None
        }
        
        promotions = obj.get("Promotions", [])
        for promo in promotions:
            result_name = promo.get("Result", "").lower()
            if result_name:
                evolution_chains[monster_name]["result"] = result_name
    
    # Process each monster
    for monster_name, evo_data in evolution_chains.items():
        obj = evo_data["obj"]
        evo_level = evo_data["evo_level"]
        
        forms = obj.get("Forms", [])
        if not forms or not forms[0].get("Released", True):
            continue
        
        element1 = forms[0].get("Element1", "")
        element2 = forms[0].get("Element2", "")
        
        if element1 == "none":
            element1 = ""
        if element2 == "none":
            element2 = ""
        
        display_name = obj.get("Name", {}).get("DefaultText", monster_name)
        
        # Determine which checkpoints this pokemon should appear in
        if evo_level == "item":
            # Item evolutions go to item_evo
            target_partitions = ["item_evo"]
        elif evo_level is not None:
            # This is a base form that evolves
            # Add to all checkpoints BEFORE the evolution level
            target_partitions = []
            for checkpoint in CHECKPOINTS:
                if checkpoint["max"] < evo_level:
                    key = f"{checkpoint['min']}-{checkpoint['max']}"
                    target_partitions.append(key)
        else:
            # Check if this is an evolution result
            is_result = False
            result_evo_level = None
            
            for other_name, other_data in evolution_chains.items():
                if other_data["result"] == monster_name:
                    is_result = True
                    result_evo_level = other_data["evo_level"]
                    break
            
            if is_result:
                # This is an evolved form
                # Add to ALL checkpoints AFTER the evolution level
                target_partitions = []
                
                if result_evo_level == "item":
                    target_partitions = ["item_evo"]
                elif result_evo_level is not None:
                    for checkpoint in CHECKPOINTS:
                        if checkpoint["min"] > result_evo_level:
                            key = f"{checkpoint['min']}-{checkpoint['max']}"
                            target_partitions.append(key)
                    
                    # If no checkpoint after evolution level, goes to none
                    if not target_partitions:
                        target_partitions = ["none"]
                else:
                    # No evolution level found, goes to none
                    target_partitions = ["none"]
            else:
                # Final form or standalone - goes to none
                target_partitions = ["none"]
        
        # Add to appropriate partitions
        for partition_key in target_partitions:
            if element1 and element1 in types:
                if display_name not in partitions[partition_key][element1]:
                    partitions[partition_key][element1].append(display_name)
            
            if element2 and element2 != element1 and element2 in types:
                if display_name not in partitions[partition_key][element2]:
                    partitions[partition_key][element2].append(display_name)
    
    return partitions

def format_lua_output(partitions):
    """Format the partitions as Lua table syntax"""
    output = []
    
    # Order: checkpoints first, then special categories
    keys = [f"{cp['min']}-{cp['max']}" for cp in CHECKPOINTS]
    keys.extend(["item_evo", "can_evolve", "none"])
    
    for partition_key in keys:
        partition = partitions[partition_key]
        output.append(f"-- Checkpoint: {partition_key}")
        output.append("{")
        
        # Add min/max for checkpoints
        if partition_key not in ["item_evo", "can_evolve", "none"]:
            min_val, max_val = partition_key.split("-")
            output.append(f"  min = {min_val},")
            output.append(f"  max = {max_val},")
        
        for type_name in sorted(partition.keys()):
            monsters = sorted(partition[type_name])
            if monsters:
                monsters_str = ', '.join(f'"{m.lower()}"' for m in monsters)
                output.append(f'  {type_name} = {{ {monsters_str} }},')
        
        output.append("}")
        output.append("")
    
    return "\n".join(output)

def main():
    if len(sys.argv) < 2:
        print("Usage: python script.py <monster_json_dir>")
        sys.exit(1)
    
    monster_dir = sys.argv[1]
    
    monsters = load_all_monsters(monster_dir)
    partitions = partition_by_checkpoints(monsters)
    lua_output = format_lua_output(partitions)
    print(lua_output)

if __name__ == "__main__":
    main()