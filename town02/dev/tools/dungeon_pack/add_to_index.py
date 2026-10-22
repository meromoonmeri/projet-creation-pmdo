import json
import os
import sys
import copy


TM_TEMPLATE = {
    "Version": "0.8.11.0",
    "Object": {
        "$type": "RogueEssence.Data.ItemData, RogueEssence",
        "Name": {
            "DefaultText": "",
            "LocalTexts": {}
        },
        "Desc": {
            "DefaultText": "",
            "LocalTexts": {}
        },
        "Released": True,
        "Comment": "",
        "Sprite": "Disc_Blue",
        "Icon": 13,
        "SortCategory": 13,
        "Price": 500,
        "Rarity": 0,
        "MaxStack": 0,
        "CannotDrop": False,
        "BagEffect": False,
        "ItemStates": [
            {
                "$type": "RogueEssence.Dungeon.ItemIDState, RogueEssence",
                "ID": ""
            }
        ],
        "GroundUseActions": [
            {
                "$type": "RogueEssence.Ground.LearnItemEvent, RogueEssence",
                "Skill": "",
                "GroundUsageType": 6,
                "Selection": 0
            }
        ]
    }
}


IDX_ENTRY_TEMPLATE = {
    "$type": "RogueEssence.Data.ItemEntrySummary, RogueEssence",
    "Icon": 13,
    "UsageType": 6,
    "States": [
        {
            "assembly": "RogueEssence, Version=0.1.0.0, Culture=neutral, PublicKeyToken=null",
            "type": "RogueEssence.Dungeon.ItemIDState"
        }
    ],
    "MaxStack": 0,
    "CannotDrop": False,
    "BagEffect": False,
    "Name": {
        "DefaultText": "",
        "LocalTexts": {}
    },
    "Released": True,
    "Comment": "",
    "SortOrder": 13
}


def title_case_move(move):
    return move.replace("_", " ").title()


def load_tm_list(path):
    with open(path, "r", encoding="utf-8") as f:
        return [line.strip() for line in f if line.strip()]


def generate_tm_file(tm_id, out_dir):
    move = tm_id.replace("tm_", "")
    move_name = title_case_move(move)

    data = copy.deepcopy(TM_TEMPLATE)
    obj = data["Object"]

    obj["Name"]["DefaultText"] = f"TM {move_name}"
    obj["Desc"]["DefaultText"] = f"Teaches the move {move_name} to a Pokémon."
    obj["ItemStates"][0]["ID"] = move
    obj["GroundUseActions"][0]["Skill"] = move

    out_path = os.path.join(out_dir, f"{tm_id}.json")
    with open(out_path, "w", encoding="utf-8") as f:
        json.dump(data, f, indent=2, ensure_ascii=False)

    print(f"Created {tm_id}.json")


def update_idx(idx_path, tm_ids):
    with open(idx_path, "r", encoding="utf-8-sig") as f:
        idx = json.load(f)

    obj = idx["Object"]

    for tm_id in tm_ids:
        if tm_id in obj:
            continue

        move = tm_id.replace("tm_", "")
        move_name = title_case_move(move)

        entry = copy.deepcopy(IDX_ENTRY_TEMPLATE)
        entry["Name"]["DefaultText"] = f"TM {move_name}"

        obj[tm_id] = entry
        print(f"Added {tm_id} to idx")

    with open(idx_path, "w", encoding="utf-8") as f:
        json.dump(idx, f, indent=2, ensure_ascii=False)


def main():
    if len(sys.argv) < 4:
        print("Usage:")
        print("  python generate_tms.py <tm_list.txt> <tm_output_dir> <items.idx.json>")
        sys.exit(1)

    tm_list_path = sys.argv[1]
    tm_out_dir = sys.argv[2]
    idx_path = sys.argv[3]

    os.makedirs(tm_out_dir, exist_ok=True)

    tm_ids = load_tm_list(tm_list_path)

    for tm_id in tm_ids:
        generate_tm_file(tm_id, tm_out_dir)

    update_idx(idx_path, tm_ids)


if __name__ == "__main__":
    main()
