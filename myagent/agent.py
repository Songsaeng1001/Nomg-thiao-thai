from google.adk.agents import Agent
from toolagent.search_places import search_places

travel_agent = Agent(
    model="gemini-1.5-pro",
    tools=[search_places]
)