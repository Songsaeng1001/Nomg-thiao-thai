import requests

def get_cat_fact()->list:
    url = "https://catfact.ninja/fact" # กำหนด url
    res = requests.get(url) # เรียก url
    if res.status_code != 200:
        return None
    data = res.Json()
    print(data)
if __name__ == "__main__":
    get_cat_fact()