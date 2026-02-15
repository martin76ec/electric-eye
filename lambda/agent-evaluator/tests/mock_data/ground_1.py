ground_truth = {
    "question": "What is Git and what are its three main file states?",
    "answer": "Git is a distributed version control system (DVCS) that helps manage projects efficiently, allowing multiple developers to collaborate. The three main file states in Git are 'Committed' (saved to the local database), 'Modified' (changed but not committed), and 'Staged' (marked to be included in the next commit).",
    "documents": ["what-is-git.md", "git-concepts.md"],
}

agent_response = {
    "question": "What is Git and what are its three main file states?",
    "answer": "Git is a distributed version control system for tracking changes in source code. It allows multiple developers to work together. Its three main file states are Committed (data is stored in the local database), Modified (file is changed but not committed), and Staged (a modified file is marked for the next commit).",
    "documents": ["what-is-git.md", "git-concepts.md"],
}


record = {
    "body": {
        "id": "test_record_1",
        "ground_truth": ground_truth,
        "response": agent_response,
    }
}
