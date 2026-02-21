from mcp.server.fastmcp import FastMCP
import psycopg2

mcp = FastMCP("travel-db")

@mcp.tool()
def search_places(province: str, max_budget: int = None):
    conn = psycopg2.connect(
        dbname="nong_thiao_thai",
        user="postgres",
        password="1234",
        host="127.0.0.1",
        port="5433"
    )

    cur = conn.cursor()

    query = """
        SELECT p.place_name, p.avg_spend, p.rating
        FROM place p
        JOIN district d ON p.district_id = d.district_id
        JOIN province pr ON d.province_id = pr.province_id
        WHERE pr.province_name = %s
    """

    params = [province]

    if max_budget:
        query += " AND p.avg_spend <= %s"
        params.append(max_budget)

    cur.execute(query, params)
    rows = cur.fetchall()

    cur.close()
    conn.close()

    result = []
    for row in rows:
        result.append({
            "place_name": row[0],
            "avg_spend": row[1],
            "rating": float(row[2])
        })

    return result


if __name__ == "__main__":
    mcp.run()