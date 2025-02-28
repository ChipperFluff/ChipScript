alias checkSize='function _check_size() { 
    if [ ! -f "$1" ]; then 
        echo -e "\e[31m[ERROR] File not found!\e[0m"; 
        return 1; 
    fi

    # Get exact file size in bytes and convert to bits
    size_bytes=$(stat -c%s "$1")
    size_bits=$(echo "$size_bytes * 8" | bc)  

    # Convert max size from KB to bits
    max_size_kb=$2
    max_size_bits=$(echo "$max_size_kb * 1024 * 8" | bc)

    if [ -z "$max_size_kb" ] || (( $(echo "$max_size_kb <= 0" | bc -l) )); then
        echo -e "\e[31m[ERROR] Invalid max size! Usage: cfs <file> <max_size_kb>\e[0m"
        return 1
    fi

    # Fix Zero Menu – Only trigger when file is actually 0 bits
    if [ "$size_bits" -eq 0 ]; then
        echo -e "\n🌀 \e[34m[ZERO MENU] File is **truly empty (0 bits used).**\e[0m"
        return 0
    fi

    # Calculate percentage
    percentage=$(echo "scale=5; ($size_bits / $max_size_bits) * 100" | bc)
    percentage_int=$(echo "$percentage" | cut -d'.' -f1)  

    # Progress bar with correct bit scaling (max out at 300%)
    bar_length=30
    max_percentage=300  
    scaled_percentage=$(echo "if ($percentage > $max_percentage) $max_percentage else $percentage" | bc)  
    filled_length=$(echo "scale=0; ($scaled_percentage * $bar_length) / 100" | bc)
    empty_length=$(echo "$bar_length - ($filled_length % $bar_length)" | bc)

    # Handle overflow
    overflow_fill=$(echo "if ($percentage > 100) $filled_length - $bar_length else 0" | bc)
    normal_fill=$(echo "if ($percentage > 100) $bar_length else $filled_length" | bc)

    progress_bar=$(printf "\e[32m%${normal_fill}s" | tr " " "#")  
    overflow_bar=$(printf "\e[31m%${overflow_fill}s" | tr " " "#")  
    remaining_bar=$(printf "\e[37m%${empty_length}s" | tr " " "-")  

    echo -e "\n📜 \e[34mFILE SIZE DETAILS\e[0m"
    echo -e "🔹 Bits Used:   $size_bits / $max_size_bits"
    echo -e "🔹 Bytes Used:  $size_bytes / $(echo "$max_size_bits / 8" | bc)"

    echo -e "\n📊 \e[34mPROGRESS BAR (Bit-by-Bit Memory Usage)\e[0m"
    echo -e "[${progress_bar}${overflow_bar}${remaining_bar}]\e[0m ($percentage%)"

    # Correctly scaled menu system
    if (( $(echo "$percentage < 50" | bc -l) )); then
        echo -e "\n🍃 \e[32m[LOOSE FIT] Your file is well within limits.\e[0m"
    elif (( $(echo "$percentage >= 90 && $percentage < 100" | bc -l) )); then
        echo -e "\n🏆 \e[33m[WIN MENU] You are near the limit but still safe!\e[0m"
    elif (( $(echo "$percentage == 100" | bc -l) )); then
        echo -e "\n🎯 \e[36m[PERFECT FIT] Your file fits exactly within the limit!\e[0m"
    elif (( $(echo "$percentage > 100" | bc -l) )); then
        over_bits=$(echo "$size_bits - $max_size_bits" | bc)
        over_bytes=$(echo "$over_bits / 8" | bc)
        echo -e "\n❌ \e[31m[LOSE MENU] UR TOO BIG!\e[0m"
        echo -e "Allowed: \e[32m${max_size_bits} bits\e[0m | Over: \e[31m+${over_bits} bits (${over_bytes} bytes)\e[0m"
        echo -e "Total: ${size_bits} bits (\e[31m${percentage}%\e[0m of allowed size)"
    else 
        echo -e "\n✅ \e[32m[UwU] Ur good! (${size_bits} bits <= ${max_size_bits} bits)\e[0m"
        echo -e "Usage: \e[32m${percentage}%\e[0m of allowed size"
    fi 

    echo -e ""
}; _check_size'
