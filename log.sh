#!/usr/bin/env bash
# 사용법: ./log.sh "오늘 한 일 요약"
#  - 오늘 날짜의 DEVLOG 항목을 만들고(없으면) 요약을 추가
#  - 커밋 + 푸시까지 한 번에 → 잔디밭 적립
set -e
cd "$(dirname "$0")"

SUMMARY="${*:-}"
DATE=$(date +%Y-%m-%d)
DOW=$(date +%u); DOWS=(일 월 화 수 목 금 토 일); DOWK=${DOWS[$DOW]}
MONTH=$(date +%Y-%m)
DIR="DEVLOG/$MONTH"
FILE="$DIR/$DATE.md"
mkdir -p "$DIR"

if [ ! -f "$FILE" ]; then
  cat > "$FILE" <<EOF
# $DATE ($DOWK)

## 오늘 한 일
- ${SUMMARY:-(작성)}

## 배운 것 / 메모
-

## 내일 할 일
- [ ]
EOF
else
  [ -n "$SUMMARY" ] && sed -i '' "/## 오늘 한 일/a\\
- $SUMMARY
" "$FILE"
fi

git add -A
git commit -q -m "devlog: $DATE ${SUMMARY:+— $SUMMARY}" || { echo "변경 없음"; exit 0; }
git push -q origin main && echo "✅ 푸시 완료 → 잔디 +1 ($DATE)"
echo "📝 $FILE"
