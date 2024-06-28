#!/bin/bash

# カレントディレクトリの各ファイルをループで処理
for file in *; do
    # ファイルが通常のファイルであることを確認（ディレクトリは除外）
    if [ -f "$file" ]; then
        # 元のファイル名から拡張子を除いた部分を取得
        filename=$(basename -- "$file")
        extension="${filename##*.}"
        filename="${filename%.*}"

        # zipファイル名を作成（元のファイル名 + .zip）
        zip_file="${filename}.zip"

        # ファイルを圧縮
        zip "$zip_file" "$file"

        # 圧縮が成功したかチェック
        if [ $? -eq 0 ]; then
            echo "$file を $zip_file に圧縮しました。"
        else
            echo "$file の圧縮中にエラーが発生しました。"
        fi
    fi
done

echo "全てのファイルの圧縮が完了しました。"
