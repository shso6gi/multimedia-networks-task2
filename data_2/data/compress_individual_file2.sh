#!/bin/bash

# 圧縮アルゴリズムと拡張子の対応
declare -A algorithms=(
    ["zip"]="zip"
    ["7z"]="7z"
    ["rar"]="rar"
)

# カレントディレクトリの各ファイルをループで処理
for file in *; do
    # ファイルが通常のファイルであることを確認（ディレクトリは除外）
    if [ -f "$file" ]; then
        # 元のファイル名から拡張子を除いた部分を取得
        filename=$(basename -- "$file")
        extension="${filename##*.}"
        filename="${filename%.*}"

        # 各アルゴリズムで圧縮
        for algorithm in "${!algorithms[@]}"; do
            # 圧縮コマンドと拡張子を取得
            compress_cmd="$algorithm"
            archive_ext="${algorithms[$algorithm]}"

            # 圧縮ファイル名を作成
            archive_file="${filename}.${archive_ext}"

            # アルゴリズムごとのディレクトリを作成
            mkdir -p "$algorithm"

            # ファイルを圧縮
            if [ "$algorithm" == "7z" ]; then
                # 7-zip の場合、-t オプションでアーカイブ形式を指定
                7z a -t7z "$algorithm/$archive_file" "$file"
            elif [ "$algorithm" == "rar" ] && command -v rar >/dev/null 2>&1; then
                # rar がインストールされている場合のみ rar で圧縮
                rar a "$algorithm/$archive_file" "$file"
            else
                # zip など、その他のアルゴリズム
                "$compress_cmd" "$algorithm/$archive_file" "$file"
            fi

            # 圧縮が成功したかチェック
            if [ $? -eq 0 ]; then
                echo "$file を ${algorithm}/$archive_file に圧縮しました。"
            else
                echo "$file の $algorithm 圧縮中にエラーが発生しました。"
            fi
        done
    fi
done

echo "全てのファイルの圧縮が完了しました。"
