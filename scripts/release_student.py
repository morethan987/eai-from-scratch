"""
Convert main branch to blank student branch
uv run scripts_student.py
"""

import subprocess
import sys
from pathlib import Path


def run_cmd(cmd: list[str]) -> str:
    try:
        res = subprocess.run(cmd, capture_output=True, text=True, check=True)
        return res.stdout.strip()
    except subprocess.CalledProcessError as e:
        print(f"[ERROR] Fail to run: {' '.join(cmd)}\n{e.stderr.strip()}")
        sys.exit(1)


def main():
    if run_cmd(["git", "branch", "--show-current"]) != "main":
        print("❌ 请在 main 分支执行此脚本！")
        sys.exit(1)

    if run_cmd(["git", "status", "--porcelain"]):
        print("❌ main 分支存在未提交修改，请先 git commit！")
        sys.exit(1)

    # 1. 切换/重置 student 分支到当前最新 main
    run_cmd(["git", "checkout", "-B", "student"])

    # 2. 清空 src/eai336 下除 __init__.py 外的所有实现文件
    src_dir = Path("src/eai336")
    for file in src_dir.rglob("*.py"):
        if file.name == "__init__.py":
            file.write_text("")  # 清空内容，保留包声明
        else:
            file.unlink()  # 删除具体实现文件

    # 3. 提交变更
    run_cmd(["git", "add", "src/"])
    run_cmd(
        [
            "git",
            "commit",
            "-m",
            "chore: release student blank-slate template",
            "--no-verify",
        ]
    )
    run_cmd(["git", "checkout", "main"])

    print("🎉 转换完成！本地 student 分支现在是完全纯净的白板。")
    print("👉 运行 'git push origin student --force' 推送到远端。")


if __name__ == "__main__":
    main()
