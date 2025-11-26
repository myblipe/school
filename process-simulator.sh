#!/bin/bash

# ============================================================================
# SYMULATOR PROCESÓW - Skrypt dla uczniów
# Wersja: 1.0
# Autor: Laboratorium Linux
# Opis: Tworzy bezpieczne procesy testowe do nauki zarządzania procesami
# ============================================================================

# Kolory do wyświetlania
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Funkcja wyświetlająca banner
show_banner() {
    clear
    echo -e "${GREEN}"
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║        SYMULATOR PROCESÓW - Laboratorium Linux           ║"
    echo "║                    Wersja 1.0                             ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Funkcja wyświetlająca pomoc
show_help() {
    show_banner
    echo -e "${CYAN}Użycie:${NC}"
    echo "  ./process_simulator.sh [OPCJA]"
    echo ""
    echo -e "${CYAN}Dostępne opcje:${NC}"
    echo "  start       - Uruchamia procesy testowe"
    echo "  stop        - Zatrzymuje wszystkie procesy testowe"
    echo "  status      - Sprawdza status procesów testowych"
    echo "  list        - Wyświetla listę aktywnych procesów testowych"
    echo "  help        - Wyświetla tę pomoc"
    echo ""
    echo -e "${YELLOW}Przykłady:${NC}"
    echo "  ./process_simulator.sh start"
    echo "  ./process_simulator.sh status"
    echo "  ./process_simulator.sh stop"
    echo ""
}

# Funkcja uruchamiająca procesy testowe
start_processes() {
    show_banner
    echo -e "${GREEN}[*] Uruchamianie procesów testowych...${NC}"
    echo ""
    
    # Sprawdź czy procesy już działają
    if pgrep -f "worker_sim" > /dev/null; then
        echo -e "${YELLOW}[!] Uwaga: Procesy testowe już działają!${NC}"
        echo -e "${YELLOW}[!] Użyj './process_simulator.sh stop' aby je zatrzymać.${NC}"
        return 1
    fi
    
    # Worker 1 - Lekki proces w tle
    (
        while true; do
            sleep 10
        done
    ) &
    WORKER1_PID=$!
    echo $WORKER1_PID > /tmp/worker1_sim.pid
    echo -e "${GREEN}[✓] Worker 1 uruchomiony (PID: $WORKER1_PID)${NC}"
    echo -e "    Opis: Lekki proces uśpiony, zużywa minimalne zasoby"
    
    # Worker 2 - Średni proces
    (
        while true; do
            sleep 5
            date > /dev/null
        done
    ) &
    WORKER2_PID=$!
    echo $WORKER2_PID > /tmp/worker2_sim.pid
    echo -e "${GREEN}[✓] Worker 2 uruchomiony (PID: $WORKER2_PID)${NC}"
    echo -e "    Opis: Średni proces, wykonuje lekkie operacje"
    
    # CPU Hog - Proces zużywający CPU
    (
        while true; do
            # Symulacja obciążenia CPU (lekka pętla)
            for i in {1..1000}; do
                echo $((i * i)) > /dev/null
            done
            sleep 1
        done
    ) &
    CPUHOG_PID=$!
    echo $CPUHOG_PID > /tmp/cpuhog_sim.pid
    echo -e "${GREEN}[✓] CPU Hog uruchomiony (PID: $CPUHOG_PID)${NC}"
    echo -e "    Opis: Proces zwiększający obciążenie CPU"
    
    # Memory User - Proces używający pamięci
    (
        # Alokacja tablicy w pamięci
        declare -a big_array
        for i in {1..10000}; do
            big_array[$i]="Data_$i"
        done
        
        while true; do
            sleep 15
        done
    ) &
    MEMUSER_PID=$!
    echo $MEMUSER_PID > /tmp/memuser_sim.pid
    echo -e "${GREEN}[✓] Memory User uruchomiony (PID: $MEMUSER_PID)${NC}"
    echo -e "    Opis: Proces alokujący pamięć RAM"
    
    # Background Task - Zadanie w tle
    (
        while true; do
            sleep 30
            echo "Background task running..." >> /tmp/background_sim.log
        done
    ) &
    BGTASK_PID=$!
    echo $BGTASK_PID > /tmp/bgtask_sim.pid
    echo -e "${GREEN}[✓] Background Task uruchomiony (PID: $BGTASK_PID)${NC}"
    echo -e "    Opis: Zadanie działające w tle, zapisuje logi"
    
    echo ""
    echo -e "${GREEN}[✓] Wszystkie procesy testowe zostały uruchomione!${NC}"
    echo ""
    echo -e "${CYAN}Możesz teraz używać poleceń:${NC}"
    echo "  ps aux | grep sim"
    echo "  top"
    echo "  kill <PID>"
    echo ""
    echo -e "${YELLOW}[!] Aby zatrzymać wszystkie procesy: ./process_simulator.sh stop${NC}"
    echo ""
}

# Funkcja zatrzymująca procesy
stop_processes() {
    show_banner
    echo -e "${YELLOW}[*] Zatrzymywanie procesów testowych...${NC}"
    echo ""
    
    STOPPED=0
    
    # Zatrzymaj Worker 1
    if [ -f /tmp/worker1_sim.pid ]; then
        PID=$(cat /tmp/worker1_sim.pid)
        if kill $PID 2>/dev/null; then
            echo -e "${GREEN}[✓] Worker 1 zatrzymany (PID: $PID)${NC}"
            STOPPED=$((STOPPED + 1))
        fi
        rm -f /tmp/worker1_sim.pid
    fi
    
    # Zatrzymaj Worker 2
    if [ -f /tmp/worker2_sim.pid ]; then
        PID=$(cat /tmp/worker2_sim.pid)
        if kill $PID 2>/dev/null; then
            echo -e "${GREEN}[✓] Worker 2 zatrzymany (PID: $PID)${NC}"
            STOPPED=$((STOPPED + 1))
        fi
        rm -f /tmp/worker2_sim.pid
    fi
    
    # Zatrzymaj CPU Hog
    if [ -f /tmp/cpuhog_sim.pid ]; then
        PID=$(cat /tmp/cpuhog_sim.pid)
        if kill $PID 2>/dev/null; then
            echo -e "${GREEN}[✓] CPU Hog zatrzymany (PID: $PID)${NC}"
            STOPPED=$((STOPPED + 1))
        fi
        rm -f /tmp/cpuhog_sim.pid
    fi
    
    # Zatrzymaj Memory User
    if [ -f /tmp/memuser_sim.pid ]; then
        PID=$(cat /tmp/memuser_sim.pid)
        if kill $PID 2>/dev/null; then
            echo -e "${GREEN}[✓] Memory User zatrzymany (PID: $PID)${NC}"
            STOPPED=$((STOPPED + 1))
        fi
        rm -f /tmp/memuser_sim.pid
    fi
    
    # Zatrzymaj Background Task
    if [ -f /tmp/bgtask_sim.pid ]; then
        PID=$(cat /tmp/bgtask_sim.pid)
        if kill $PID 2>/dev/null; then
            echo -e "${GREEN}[✓] Background Task zatrzymany (PID: $PID)${NC}"
            STOPPED=$((STOPPED + 1))
        fi
        rm -f /tmp/bgtask_sim.pid
        rm -f /tmp/background_sim.log
    fi
    
    echo ""
    if [ $STOPPED -eq 0 ]; then
        echo -e "${YELLOW}[!] Nie znaleziono żadnych procesów testowych do zatrzymania.${NC}"
    else
        echo -e "${GREEN}[✓] Zatrzymano $STOPPED proces(ów) testowych.${NC}"
    fi
    echo ""
}

# Funkcja sprawdzająca status
check_status() {
    show_banner
    echo -e "${CYAN}[*] Status procesów testowych:${NC}"
    echo ""
    
    RUNNING=0
    
    # Sprawdź Worker 1
    if [ -f /tmp/worker1_sim.pid ]; then
        PID=$(cat /tmp/worker1_sim.pid)
        if kill -0 $PID 2>/dev/null; then
            echo -e "${GREEN}[✓] Worker 1 działa (PID: $PID)${NC}"
            RUNNING=$((RUNNING + 1))
        else
            echo -e "${RED}[✗] Worker 1 nie działa${NC}"
            rm -f /tmp/worker1_sim.pid
        fi
    else
        echo -e "${RED}[✗] Worker 1 nie uruchomiony${NC}"
    fi
    
    # Sprawdź Worker 2
    if [ -f /tmp/worker2_sim.pid ]; then
        PID=$(cat /tmp/worker2_sim.pid)
        if kill -0 $PID 2>/dev/null; then
            echo -e "${GREEN}[✓] Worker 2 działa (PID: $PID)${NC}"
            RUNNING=$((RUNNING + 1))
        else
            echo -e "${RED}[✗] Worker 2 nie działa${NC}"
            rm -f /tmp/worker2_sim.pid
        fi
    else
        echo -e "${RED}[✗] Worker 2 nie uruchomiony${NC}"
    fi
    
    # Sprawdź CPU Hog
    if [ -f /tmp/cpuhog_sim.pid ]; then
        PID=$(cat /tmp/cpuhog_sim.pid)
        if kill -0 $PID 2>/dev/null; then
            echo -e "${GREEN}[✓] CPU Hog działa (PID: $PID)${NC}"
            RUNNING=$((RUNNING + 1))
        else
            echo -e "${RED}[✗] CPU Hog nie działa${NC}"
            rm -f /tmp/cpuhog_sim.pid
        fi
    else
        echo -e "${RED}[✗] CPU Hog nie uruchomiony${NC}"
    fi
    
    # Sprawdź Memory User
    if [ -f /tmp/memuser_sim.pid ]; then
        PID=$(cat /tmp/memuser_sim.pid)
        if kill -0 $PID 2>/dev/null; then
            echo -e "${GREEN}[✓] Memory User działa (PID: $PID)${NC}"
            RUNNING=$((RUNNING + 1))
        else
            echo -e "${RED}[✗] Memory User nie działa${NC}"
            rm -f /tmp/memuser_sim.pid
        fi
    else
        echo -e "${RED}[✗] Memory User nie uruchomiony${NC}"
    fi
    
    # Sprawdź Background Task
    if [ -f /tmp/bgtask_sim.pid ]; then
        PID=$(cat /tmp/bgtask_sim.pid)
        if kill -0 $PID 2>/dev/null; then
            echo -e "${GREEN}[✓] Background Task działa (PID: $PID)${NC}"
            RUNNING=$((RUNNING + 1))
        else
            echo -e "${RED}[✗] Background Task nie działa${NC}"
            rm -f /tmp/bgtask_sim.pid
        fi
    else
        echo -e "${RED}[✗] Background Task nie uruchomiony${NC}"
    fi
    
    echo ""
    echo -e "${CYAN}Podsumowanie: $RUNNING/5 procesów działa${NC}"
    echo ""
}

# Funkcja listująca procesy
list_processes() {
    show_banner
    echo -e "${CYAN}[*] Lista aktywnych procesów testowych:${NC}"
    echo ""
    
    if ! pgrep -f "worker_sim\|cpuhog_sim\|memuser_sim\|bgtask_sim" > /dev/null; then
        echo -e "${YELLOW}[!] Brak aktywnych procesów testowych.${NC}"
        echo -e "${YELLOW}[!] Użyj './process_simulator.sh start' aby je uruchomić.${NC}"
        echo ""
        return
    fi
    
    echo -e "${GREEN}Używając 'ps aux':${NC}"
    ps aux | head -1
    ps aux | grep -E "worker_sim|cpuhog_sim|memuser_sim|bgtask_sim" | grep -v grep
    
    echo ""
    echo -e "${CYAN}Możesz też użyć:${NC}"
    echo "  ps aux | grep sim"
    echo "  top"
    echo ""
}

# Główna funkcja
main() {
    case "$1" in
        start)
            start_processes
            ;;
        stop)
            stop_processes
            ;;
        status)
            check_status
            ;;
        list)
            list_processes
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            show_help
            echo -e "${RED}[!] Błąd: Nieprawidłowa opcja '$1'${NC}"
            echo ""
            exit 1
            ;;
    esac
}

# Uruchom główną funkcję
main "$@"
