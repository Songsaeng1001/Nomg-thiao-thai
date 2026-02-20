import psycopg2
def search_places(province: str, category: str = None, max_budget: int = None):
    """
    Search places by province, category and budget.
    """

    conn = psycopg2.connect(
        dbname="nong_thiao_thai",
        user="postgres",
        password="1234",
        host="localhost",
        port="5432"
    )

    cur = conn.cursor()

    query = """
    SELECT p.place_name, p.avg_spend, p.rating
    FROM place p
    JOIN district d ON p.district_id = d.district_id
    JOIN province pr ON d.province_id = pr.province_id
    JOIN category c ON p.category_id = c.category_id
    WHERE pr.province_name = %s
    """

    params = [province]

    if category:
        query += " AND c.category_name = %s"
        params.append(category)

    if max_budget:
        query += " AND p.avg_spend <= %s"
        params.append(max_budget)

    query += " ORDER BY p.rating DESC LIMIT 10"

    cur.execute(query, params)
    results = cur.fetchall()

    cur.close()
    conn.close()

    return results