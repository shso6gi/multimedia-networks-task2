#!/bin/bash

# JSON 出力の開始
echo '{'
echo '  "results": ['

# カウンタ初期化（コンマの制御用）
count=0

# 7z, rar, zip ディレクトリに対してループ
for dir in 7z rar zip; do
    # 各ディレクトリ内のファイルに対して再帰的にループ
    find "$dir" -type f | while read -r file; do
        # ./entropy コマンドの実行結果を取得
        output=$(./entropy "$file")
        
        # 出力から必要な情報を抽出
        file_size=$(echo "$output" | grep "file size" | awk '{print $NF}')
        entropy=$(echo "$output" | grep "entropy" | awk '{print $NF}')
        ideal_size=$(echo "$output" | grep "ideal size" | awk '{print $NF}')
        
        # JSON オブジェクトの出力
        if [ $count -ne 0 ]; then
            echo ','
        fi
        echo '    {'
        echo "      \"file\": \"$file\","
        echo "      \"file_size\": $file_size,"
        echo "      \"entropy\": $entropy,"
        echo "      \"ideal_size\": $ideal_size"
        echo -n '    }'
        
        # カウンタをインクリメント
        ((count++))
    done
done

# JSON 出力の終了
echo
echo '  ]'
echo '}'
