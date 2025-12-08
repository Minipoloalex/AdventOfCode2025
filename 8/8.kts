class DSU(val n: Int) {
    val p = IntArray(n) { -1 };
    fun is_head(x: Int): Boolean {
        return p[x] < 0
    }
    fun set(x: Int): Int {
        if (is_head(x)) return x
        p[x] = set(p[x])
        return p[x]
    }
    fun same_set(u: Int, v: Int): Boolean {
        return set(u) == set(v)
    }
    fun size(x: Int): Int {
        return -p[set(x)]
    }
    fun unite(u: Int, v: Int) {
        var pu = set(u)
        var pv = set(v)
        if (size(pu) < size(pv)) {
            pu = pv.also { pv = pu }    // swap(pu, pv)
        }
        // pu has largest size
        p[pu] += p[pv]
        p[pv] = pu
    }
}

fun distsq(a: IntArray, b: IntArray): Long {
    var ans = 0.toLong()
    for (i in 0 until 3) {
        ans += (a[i] - b[i]).toLong() * (a[i] - b[i])
    }
    return ans
}

fun kruskal_part1(n: Int, edges: ArrayList<LongArray>, max_steps: Int): Long {
    var cnt = 0
    val dsu = DSU(n)
    for (i in 0 until minOf(edges.size, max_steps)) {
        val edge = edges[i]
        val u = edge[1].toInt()
        val v = edge[2].toInt()
        if (!dsu.same_set(u, v)) {
            dsu.unite(u, v)
        }
    }

    val clusters = ArrayList<Int>()
    for (i in 0 until n) {
        if (dsu.is_head(i)) {
            clusters.add(dsu.size(i))
        }
    }
    clusters.sortBy({ -it })
    var ans = 1.toLong()
    for (i in 0 until minOf(clusters.size, 3)) {
        ans *= clusters[i]
    }
    return ans
}

fun kruskal_part2(n: Int, pts: ArrayList<IntArray>, edges: ArrayList<LongArray>): Long {
    var cnt = 0
    val dsu = DSU(n)
    var ans = 0.toLong()
    for (edge in edges) {
        val u = edge[1].toInt()
        val v = edge[2].toInt()
        if (!dsu.same_set(u, v)) {
            dsu.unite(u, v)
            ans = pts[u][0].toLong() * pts[v][0]
        }
    }
    return ans
}

fun main() {
    val pts = ArrayList<IntArray>()
    while (true) {
        val line = readln()
        if (line == "") break
        val coords = line.split(",").map { it.toInt() }.toIntArray()
        pts.add(coords);
    }
    val n = pts.size

    val edges = ArrayList<LongArray>()
    for (i in 0 until n) {
        for (j in (i+1) until n) {
            edges.add(longArrayOf(distsq(pts[i], pts[j]), i.toLong(), j.toLong()))
        }
    }
    edges.sortBy({ it[0] })
    val MAX_STEPS = 1000
    val ans1 = kruskal_part1(n, edges, MAX_STEPS)
    val ans2 = kruskal_part2(n, pts, edges)
    println("Part 1: $ans1, Part2: $ans2")
}

main()
