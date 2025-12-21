from pathlib import Path
import sys

SCRIPT_DIR = Path(__file__).resolve().parent


def main() -> None:
    day = sys.argv[1].zfill(2)

    with (SCRIPT_DIR / "aoc" / "include" / "days" / "day00.hpp").open() as f:
        header_template = f.read()

    with (SCRIPT_DIR / "aoc" / "src" / "days" / "day00.cpp").open() as f:
        src_template = f.read()

    header_template = header_template.replace("Day00", f"Day{day}")
    src_template = (
        src_template.replace("Day00", f"Day{day}")
        .replace("Day(0)", f"Day({int(day)})")
        .replace("day00.hpp", f"day{day}.hpp")
    )

    with (SCRIPT_DIR / "aoc" / "include" / "days" / f"day{day}.hpp").open("w") as f:
        f.write(header_template)

    with (SCRIPT_DIR / "aoc" / "src" / "days" / f"day{day}.cpp").open("w") as f:
        f.write(src_template)

    print(
        "Done!  Make sure to manually add the new .hpp and .cpp to the CMakeLists.txt, and add the day to the vector in main.cpp."
    )


if __name__ == "__main__":
    main()
