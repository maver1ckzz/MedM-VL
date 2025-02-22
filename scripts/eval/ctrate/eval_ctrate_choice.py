import argparse
import json
import re
from tqdm import tqdm


def main(args):
    with open(args.answer_path, "r") as f:
        answer_list = json.load(f)
    with open(args.predict_path, "r") as f:
        predict_list = json.load(f)

    results = []
    for answer_dict, predict in tqdm(zip(answer_list, predict_list), total=len(answer_list)):
        choices = re.findall(r'\((.*?)\)', answer_dict["answer"].strip())
        if len(choices) < 1:
            continue
        answer = "(" + choices[0] + ")"
        predict = predict.strip()
        question_type = answer_dict["type"]

        correct = answer in predict
        results.append({
            "id": answer_dict["id"],
            "answer": answer,
            "predict": predict,
            "type": question_type,
            "correct": correct,
        })

    with open(args.result_path, "w") as f:
        json.dump(results, f)

    # calculate average scores
    metric_list = ["correct"]
    for metric_name in metric_list:
        metric_scores = [r[metric_name] for r in results]
        print(f"{metric_name}: {sum(metric_scores) / len(metric_scores)}")

    # calculate average scores by question type
    type_list = sorted(set([r["type"] for r in results]))
    if len(type_list) > 1:
        for question_type in type_list:
            print()
            print(f"Question type: {question_type}")
            for metric_name in metric_list:
                metric_scores = [r[metric_name] for r in results if r["type"] == question_type]
                print(f"{metric_name}: {sum(metric_scores) / len(metric_scores)}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--answer_path", type=str, default=None)
    parser.add_argument("--predict_path", type=str, default=None)
    parser.add_argument("--result_path", type=str, default=None)
    args = parser.parse_args()

    main(args)
