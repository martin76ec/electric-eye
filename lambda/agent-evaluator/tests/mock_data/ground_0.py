ground_truth = {
    "question": "What is Amazon SageMaker AI and what are its capabilities?",
    "answer": "Amazon SageMaker AI (formerly Amazon SageMaker) is a fully managed service designed to help you build, train, and deploy machine learning models at scale. This includes building FMs from scratch, using tools like notebooks, debuggers, profilers, pipelines, and MLOps. It provides extensive customization options and full control over the entire machine learning workflow.",
    "documents": [
        "sage-maker-guide.md",
        "ml-ops.md",
        "pipeline-design.md",
        "ml-ops-aws.md",
        "full-control.md",
    ],
}

agent_response = {
    "question": "What is Amazon SageMaker AI and what are its capabilities?",
    "answer": "Amazon SageMaker AI (formerly Amazon SageMaker) is a fully managed service designed to help you build, train, and deploy machine learning models at scale. This includes building FMs from scratch, using tools like notebooks, debuggers, profilers, pipelines, and MLOps. It provides extensive customization options and full control over the entire machine learning workflow.",
    "documents": ["sage-maker-guide.md", "pipeline-design.md", "aws-guide.md"],
}

record = {
    "body": {
        "id": "test_record_0",
        "ground_truth": ground_truth,
        "response": agent_response,
    }
}
