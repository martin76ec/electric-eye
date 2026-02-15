ground_truth = {
    "question": "What are the inputs and outputs of photosynthesis?",
    "answer": "The inputs for photosynthesis are sunlight, water (H2O), and carbon dioxide (CO2). The outputs are glucose (sugar) and oxygen (O2).",
    "documents": ["photosynthesis_inputs.md", "photosynthesis_outputs.md"],
}

agent_response = {
    "question": "What are the inputs and outputs of photosynthesis?",
    "answer": "The inputs for photosynthesis are sunlight, water, and carbon dioxide.",
    "documents": ["photosynthesis_inputs.md"],
}

record = {
    "body": {
        "id": "test_record_2",
        "ground_truth": ground_truth,
        "response": agent_response,
    }
}
