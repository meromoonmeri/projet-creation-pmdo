import os
import sys
import json

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

def build_evolution_maps(monsters):
    """Build maps of evolution relationships"""
    is_evolution_result = set()
    has_promotion = set()
    
    for base_name, obj in monsters.items():
        promotions = obj.get("Promotions", [])
        if promotions:
            has_promotion.add(base_name)
            
        for promo in promotions:
            result_name = promo.get("Result", "").lower()
            if result_name:
                is_evolution_result.add(result_name)
    
    return is_evolution_result, has_promotion

def get_partition_key(evo_level):
    """Get partition key based on level (every 5 levels)"""
    if evo_level <= 5:
        return "1-5"
    elif evo_level <= 10:
        return "6-10"
    elif evo_level <= 15:
        return "11-15"
    elif evo_level <= 20:
        return "16-20"
    elif evo_level <= 25:
        return "21-25"
    elif evo_level <= 30:
        return "26-30"
    elif evo_level <= 35:
        return "31-35"
    elif evo_level <= 40:
        return "36-40"
    elif evo_level <= 45:
        return "41-45"
    elif evo_level <= 50:
        return "46-50"
    elif evo_level <= 55:
        return "51-55"
    elif evo_level <= 60:
        return "56-60"
    elif evo_level <= 65:
        return "61-65"
    elif evo_level <= 70:
        return "66-70"
    else:
        return "none"

def partition_by_evolution_and_type(monsters, is_evolution_result, has_promotion):
    """
    Partitions monsters into groups based on evolution level and type.
    Uses the EVOLVED FORM (Result) not the base form.
    Base forms go to 'can_evolve', final forms go to 'none'.
    """
    partitions = {
        "1-5": {},
        "6-10": {},
        "11-15": {},
        "16-20": {},
        "21-25": {},
        "26-30": {},
        "31-35": {},
        "36-40": {},
        "41-45": {},
        "46-50": {},
        "51-55": {},
        "56-60": {},
        "61-65": {},
        "66-70": {},
        "item_evo": {},  # Item evolutions
        "can_evolve": {},
        "none": {}
    }
    
    # Initialize type lists for each partition
    types = ["normal", "fire", "water", "grass", "electric", "ice", "fighting", 
             "poison", "ground", "flying", "psychic", "bug", "rock", "ghost", 
             "dragon", "dark", "steel", "fairy"]
    
    for partition in partitions.values():
        for type_name in types:
            partition[type_name] = []
    
    # Track which monsters have been placed
    placed_monsters = set()
    
    # First pass: Place evolved forms
    for base_name, obj in monsters.items():
        promotions = obj.get("Promotions", [])
        
        for promo in promotions:
            result_name = promo.get("Result", "").lower()
            details = promo.get("Details", [])
            
            evo_level = None
            is_item_evo = False
            
            for detail in details:
                detail_type = detail.get("$type", "")
                
                if detail_type == "PMDC.Data.EvoLevel, PMDC":
                    evo_level = detail.get("Level")
                    break
                elif detail_type == "PMDC.Data.EvoItem, PMDC":
                    is_item_evo = True
                    break
            
            if evo_level is None and not is_item_evo:
                continue
            
            if not result_name:
                continue
            
            # Look up the evolved form
            if result_name not in monsters:
                print(f"Warning: Evolution result '{result_name}' not found for '{base_name}'", file=sys.stderr)
                continue
            
            evolved_obj = monsters[result_name]
            forms = evolved_obj.get("Forms", [])
            if not forms:
                continue
            
            # Skip if the evolved form is unreleased
            if not forms[0].get("Released", True):
                continue
            
            element1 = forms[0].get("Element1", "")
            element2 = forms[0].get("Element2", "")
            
            # Ignore "none" elements
            if element1 == "none":
                element1 = ""
            if element2 == "none":
                element2 = ""
            
            # Determine partition based on evolution method
            if is_item_evo:
                partition_key = "item_evo"
            else:
                partition_key = get_partition_key(evo_level)
            
            # Add the EVOLVED form to partitions
            evolved_display_name = evolved_obj.get("Name", {}).get("DefaultText", result_name)
            
            # Add to primary type
            if element1 and element1 in types:
                if evolved_display_name not in partitions[partition_key][element1]:
                    partitions[partition_key][element1].append(evolved_display_name)
            
            # Add to secondary type if different
            if element2 and element2 != element1 and element2 in types:
                if evolved_display_name not in partitions[partition_key][element2]:
                    partitions[partition_key][element2].append(evolved_display_name)
            
            placed_monsters.add(result_name)
    
    # Second pass: Place remaining monsters into can_evolve or none
    for monster_name, obj in monsters.items():
        # Skip if this monster was already placed as an evolution result
        if monster_name in placed_monsters:
            continue
        
        forms = obj.get("Forms", [])
        if not forms:
            continue
        
        # Skip if unreleased
        if not forms[0].get("Released", True):
            continue
        
        element1 = forms[0].get("Element1", "")
        element2 = forms[0].get("Element2", "")
        
        # Ignore "none" elements
        if element1 == "none":
            element1 = ""
        if element2 == "none":
            element2 = ""
        
        display_name = obj.get("Name", {}).get("DefaultText", monster_name)
        
        # Determine if it can evolve or is a final form
        partition_key = "can_evolve" if monster_name in has_promotion else "none"
        
        # Add to partition
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
    
    ranges = ["1-5", "6-10", "11-15", "16-20", "21-25", "26-30", "31-35", "36-40", 
              "41-45", "46-50", "51-55", "56-60", "61-65", "66-70", "item_evo", "can_evolve", "none"]
    
    for level_range in ranges:
        partition = partitions[level_range]
        output.append(f"-- Level Range: {level_range}")
        output.append("{")
        
        # Add min/max for level ranges
        if level_range not in ["item_evo", "can_evolve", "none"]:
            min_val, max_val = level_range.split("-")
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
    
    # First pass: load all monsters
    monsters = load_all_monsters(monster_dir)
    
    # Build evolution maps
    is_evolution_result, has_promotion = build_evolution_maps(monsters)
    
    # Partition by evolution
    partitions = partition_by_evolution_and_type(monsters, is_evolution_result, has_promotion)
    
    lua_output = format_lua_output(partitions)
    print(lua_output)

if __name__ == "__main__":
    main()