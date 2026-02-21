from google.adk.agents import Agent
from google.adk.models import Gemini
import psycopg2
import os


# -------------------------
# Database Connection
# -------------------------

def get_connection():
    return psycopg2.connect(
        host=os.getenv("DB_HOST"),
        port=os.getenv("DB_PORT"),
        database=os.getenv("DB_NAME"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD"),
    )


# -------------------------
# Tools
# -------------------------

def get_province_count() -> int:
    """คืนค่าจำนวนจังหวัดทั้งหมด"""
    with get_connection() as conn:
        with conn.cursor() as cursor:
            cursor.execute("SELECT COUNT(*) FROM province;")
            result = cursor.fetchone()
            return result[0] if result else 0


def get_place_count() -> int:
    """คืนค่าจำนวนสถานที่ทั้งหมด"""
    with get_connection() as conn:
        with conn.cursor() as cursor:
            cursor.execute("SELECT COUNT(*) FROM place;")
            result = cursor.fetchone()
            return result[0] if result else 0


def run_query(sql: str) -> str:
    """
    ใช้รัน SELECT query กับฐานข้อมูล
    อนุญาตเฉพาะ SELECT เท่านั้น
    """
    if not sql.strip().lower().startswith("select"):
        return "อนุญาตเฉพาะ SELECT เท่านั้น"

    with get_connection() as conn:
        with conn.cursor() as cursor:
            cursor.execute(sql)
            rows = cursor.fetchall()
            return str(rows)


# -------------------------
# Root Agent (สำคัญมาก)
# -------------------------

root_agent = Agent(
    name="myagent",
    model=Gemini(model="gemini-2.5-flash"),
    instruction=(
    "คุณเป็นผู้ช่วยฐานข้อมูลท่องเที่ยว "
    "โครงสร้างตารางมีดังนี้:\n"
    "region(region_id, region_name)\n"
    "province(province_id, province_name, region_id)\n"
    "place(place_id, place_name, province_id)\n"
    "district(district_id, district_name, province_id)\n"
    "trip(trip_id, province_id)\n"
    "trip_activity(trip_activity_id"
    ),
    tools=[
        get_province_count,
        get_place_count,
        run_query
    ],
)