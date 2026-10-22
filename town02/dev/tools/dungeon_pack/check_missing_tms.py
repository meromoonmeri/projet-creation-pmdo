import os
import sys
import json


def get_existing_tms(tm_dir):
    tms = set()
    for filename in os.listdir(tm_dir):
        name, _ = os.path.splitext(filename)
        if name.startswith("tm_"):
            tms.add(name)
    return tms


def get_required_tms(monster_dir):
    required = set()

    for filename in os.listdir(monster_dir):
        if not filename.lower().endswith(".json"):
            continue

        path = os.path.join(monster_dir, filename)

        try:
            with open(path, "r", encoding="utf-8-sig") as f:
                data = json.load(f)
        except Exception as e:
            print(f"Skipping {filename}: {e}")
            continue

        forms = data.get("Object", {}).get("Forms", [])
        for form in forms:
            for entry in form.get("TeachSkills", []):
                skill = entry.get("Skill")
                if skill:
                    required.add(f"tm_{skill}")

    return required


def main():
    if len(sys.argv) < 3:
        print("Usage: python find_missing_tms.py <tm_dir> <monster_json_dir>")
        sys.exit(1)

    tm_dir = sys.argv[1]
    monster_dir = sys.argv[2]

    existing_tms = get_existing_tms(tm_dir)
    required_tms = get_required_tms(monster_dir)

    missing = sorted(required_tms - existing_tms)

    print("[")
    for tm in missing:
        print(f'  "{tm}",')
    print("]")


if __name__ == "__main__":
    main()
