ground_truth = {
    "question": "What is a 'git commit'?",
    "answer": "A 'git commit' is a command that saves your changes to the local repository. It includes a unique ID and a descriptive message.",
    "documents": ["git_commit.md"],
}

agent_response = {
    "question": "What is a 'git commit'?",
    "answer": "A 'git commit' is a lightweight, standalone, executable package of software that includes everything needed to run an application.",
    "documents": ["docker_image.md"],
}

record = {
    "body": {
        "id": "test_record_3",
        "ground_truth": ground_truth,
        "response": agent_response,
    }
}
