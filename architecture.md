---
title: AI Digital Twin App Architecture
description: System architecture for the AI Digital Twin application using FastAPI, Next.js, and OpenAI API.
---

# AI Digital Twin App Architecture



![AI Digital Twin App Architecture](public/architecture.png)

![Gemini Generated Architecture](public/Gemini_Generated_Image.png)

![User-Web Interaction](public/User-Web-Interaction.png)

## Components

- **User (Web Browser):** Interacts with the application UI.
- **Next.js Frontend:** Handles UI, static assets, and API requests to the backend.
- **FastAPI Backend:** Manages chat logic, session memory, and OpenAI API calls.
- **OpenAI GPT-4o:** Provides AI-generated responses.
- **Memory (JSON Files):** Stores conversation history per session.
- **me.txt Personality File:** Contains the system prompt/personality for the assistant.
- **Public Directory:** Serves static assets for the frontend.

## Data Flow
1. User sends a message via the frontend.
2. Frontend sends the message to the backend `/chat` endpoint.
3. Backend loads session memory and personality, builds the prompt, and calls OpenAI API.
4. OpenAI returns a response, which is saved to memory and sent back to the frontend.
5. Frontend displays the assistant's response to the user.
