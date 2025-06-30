#!/bin/bash

# Clear screen
clear

# Color definitions
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
PURPLE='\033[1;35m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Banner
echo -e "${PURPLE}╔════════════════════════════════════════════╗"
echo -e "║${CYAN}     ____  _______  ______  _______  __    ${PURPLE}║"
echo -e "║${CYAN}    / __ \/ ___/ / / / __ \/ ___/ / / /    ${PURPLE}║"
echo -e "║${CYAN}   / /_/ / /__/ /_/ / / / / /__/ /_/ /     ${PURPLE}║"
echo -e "║${CYAN}  / .___/\___/\__,_/_/ /_/\___/\__,_/      ${PURPLE}║"
echo -e "║${CYAN} /_/                                        ${PURPLE}║"
echo -e "║                                                    ║"
echo -e "║${YELLOW}         SMS SPAM BLOCKER FOR TERMUX         ${PURPLE}║"
echo -e "║${RED}             Created by ${BLUE}F${GREEN}A${YELLOW}Z${RED}O${BLUE}2${GREEN}8${RED}             ${PURPLE}║"
echo -e "╚════════════════════════════════════════════╝${NC}"

# Main menu
echo -e "\n${GREEN}1. ${WHITE}Block SMS Spam"
echo -e "${GREEN}2. ${WHITE}View Blocked Numbers"
echo -e "${GREEN}3. ${WHITE}Add Custom Filter"
echo -e "${GREEN}4. ${WHITE}Social Media Links"
echo -e "${GREEN}5. ${WHITE}Exit${NC}"

# Function to block SMS spam
block_spam() {
    echo -e "\n${YELLOW}[*] ${WHITE}Setting up SMS spam blocker..."
    
    # Check for required permissions
    if ! termux-sms-list | grep -q "error"; then
        echo -e "${GREEN}[+] ${WHITE}SMS permissions granted"
    else
        echo -e "${RED}[!] ${WHITE}Please grant SMS permissions"
        termux-sms-list
        return
    fi
    
    # Create spam filter
    echo -e "\n${YELLOW}[*] ${WHITE}Creating spam filters..."
    mkdir -p ~/spam_filter
    cat > ~/spam_filter/spam_keywords.txt << EOF
free
win
prize
offer
congratulations
cash
claim
urgent
loan
EOF
    
    echo -e "${GREEN}[+] ${WHITE}Default spam keywords added"
    
    # Create blocking script
    cat > ~/spam_filter/block_spam.sh << 'EOF'
#!/bin/bash
while true; do
    termux-sms-list -l 10 | grep -i -f ~/spam_filter/spam_keywords.txt | \
    awk '/"number": "/ {print $2}' | tr -d '",' | \
    while read -r number; do
        termux-sms-block "$number"
        echo "Blocked spam from: $number"
    done
    sleep 60
done
EOF
    
    chmod +x ~/spam_filter/block_spam.sh
    echo -e "${GREEN}[+] ${WHITE}Blocking script created"
    
    # Add to startup
    echo -e "\n${YELLOW}[*] ${WHITE}Adding to startup..."
    if ! grep -q "block_spam.sh" ~/.bashrc; then
        echo "nohup ~/spam_filter/block_spam.sh > /dev/null 2>&1 &" >> ~/.bashrc
        echo -e "${GREEN}[+] ${WHITE}Added to startup"
    else
        echo -e "${BLUE}[i] ${WHITE}Already configured to run at startup"
    fi
    
    # Start the blocker
    nohup ~/spam_filter/block_spam.sh > /dev/null 2>&1 &
    echo -e "\n${GREEN}[+] ${WHITE}SMS spam blocker is now running in background!"
    echo -e "${YELLOW}[*] ${WHITE}It will automatically check for spam every minute"
}

# Function to show social media links
show_links() {
    echo -e "\n${CYAN}╔════════════════════════════════════════════╗"
    echo -e "║${PURPLE}          ${BLUE}F${GREEN}A${YELLOW}Z${RED}O${BLUE}2${GREEN}8${PURPLE}'s Social Media Links         ${CYAN}║"
    echo -e "╚════════════════════════════════════════════╝${NC}"
    echo -e "${GREEN}Telegram: ${WHITE}https://t.me/Tech45Tz"
    echo -e "${BLUE}WhatsApp: ${WHITE}https://wa.me/255675007732" # Replace with your actual WhatsApp link
    echo -e "${RED}YouTube: ${WHITE}https://youtube.com/fazo_28" # Replace with your actual YouTube if any
    echo -e "${PURPLE}Other: ${WHITE}https://fazo26.blogspot.com" # Add any other links
    echo -e "\n${YELLOW}Feel free to connect with me!${NC}"
}

# Main loop
while true; do
    echo -e "\n${BLUE}Enter your choice (1-5): ${NC}"
    read choice
    
    case $choice in
        1) block_spam ;;
        2) echo -e "\n${YELLOW}Blocked numbers will be shown here${NC}" ;;
        3) echo -e "\n${YELLOW}Custom filter option would go here${NC}" ;;
        4) show_links ;;
        5) echo -e "\n${RED}Exiting...${NC}"; exit 0 ;;
        *) echo -e "\n${RED}Invalid choice! Please select 1-5${NC}" ;;
    esac
done
