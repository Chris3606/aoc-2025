import dataclasses
import math

@dataclasses.dataclass(eq=False)
class Point3d:
    x: int
    y: int
    z: int

    def straight_line_distance(self, other: "Point3d") -> float:
        dx = abs(other.x - self.x)
        dy = abs(other.y - self.y)
        dz = abs(other.z - self.z)

        return math.sqrt(dx * dx + dy * dy + dz * dz)

    def __repr__(self) -> str:
        return f"({self.x}, {self.y}, {self.z})"

def parse_input(path: str) -> list[Point3d]:
    with open(path, "r", encoding="utf-8") as f:
        lines = f.readlines()
    

    data = []
    for line in lines:
        split = [int(i) for i in line.split(',')]
        data.append(Point3d(split[0], split[1], split[2]))
    
    return data

def find_point(circuits: list[set[Point3d]], point: Point3d) -> int:
    for idx, circuit in enumerate(circuits):
        if point in circuit:
            return idx
    
    return -1

def main() -> None:
    data = parse_input("inputs/day08_sample.txt")
    data = parse_input("inputs/day08.txt")

    pairs = []
    for idx, p in enumerate(data):
        for p2 in data[idx + 1:]:
            pairs.append((p, p2, p.straight_line_distance(p2)))
    
    pairs.sort(key=lambda k: k[2])
    # print(data)
    
    circuits: list[set[Point3d]] = [set([p]) for p in data]
    for p1, p2, dist in pairs:
        # print(f"processing {p1} and {p2}")
        p1_idx = find_point(circuits, p1)
        p2_idx = find_point(circuits, p2)

        # print(f"P1 is in set: {circuits[p1_idx] if p1_idx != -1 else 'None'}")
        # print(f"P2 is in set: {circuits[p2_idx] if p2_idx != -1 else 'None'}")
        

        if p1_idx == -1 or p2_idx == -1:
            raise Exception("Foo")
        else:
            if p1_idx == p2_idx:
                continue
            circuits[p1_idx] = circuits[p1_idx].union(circuits[p2_idx])
            del circuits[p2_idx]
        
        if len(circuits) == 1:
            print(f"Part 2: {p1.x * p2.x}")
            break
        
        # print(circuits)
        # print()
    
    circuits.sort(key=len, reverse=True)

    print([len(x) for x in circuits])

    # print(f"Part 1: {math.prod([len(x) for x in circuits[:3]])}")





if __name__ == "__main__":
    main()