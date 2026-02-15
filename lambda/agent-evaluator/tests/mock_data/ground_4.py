ground_truth = {
    "question": "What is the 'Isolation' property in ACID?",
    "answer": "Isolation ensures that concurrent transactions do not affect each other, making it seem as if they were executed one after another (sequentially).",
    "documents": ["db_acid_i.md"],
}

agent_response = {
    "question": "What is the 'Isolation' property in ACID?",
    "answer": "Isolation is the property that ensures any data written to the database is valid according to all defined rules and constraints. It keeps the database in a valid state.",
    "documents": ["db_acid_c.md", "db_acid_i.md"],
}

record = {
    "body": {
        "id": "test_record_4",
        "ground_truth": ground_truth,
        "response": agent_response,
    }
}
