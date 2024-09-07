#!/bin/bash

# Verifica se Zenity è installato
if ! command -v zenity &> /dev/null; then
    echo "Zenity is not installed. Install it with: sudo apt-get install zenity"
    echo "Zenity non è installato. Installalo con: sudo apt-get install zenity"
    exit 1
fi

# File di configurazione per i servizi DNS
CONFIG_FILE="$HOME/.dns_services.conf"

# Funzione per gestire le traduzioni
translate() {
    local key="$1"
    if [[ "$LANG" == it_* ]]; then
        case "$key" in
            "DNS_Management") echo "Gestione DNS" ;;
            "Change_DNS") echo "Cambia DNS" ;;
            "Add_DNS_Server") echo "Aggiungi nuovo server DNS" ;;
            "Edit_DNS_Server") echo "Modifica server DNS esistente" ;;
            "Delete_DNS_Server") echo "Elimina server DNS" ;;
            "Current_DNS") echo "DNS attuali" ;;
            "Select_DNS_Service") echo "Seleziona Servizio DNS" ;;
            "Custom_DNS") echo "DNS Personalizzato" ;;
            "Enter_DNS_Addresses") echo "Inserisci gli indirizzi DNS separati da spazi" ;;
            "Add_New_DNS_Server") echo "Aggiungi nuovo server DNS" ;;
            "Enter_New_DNS_Name") echo "Inserisci il nome del nuovo server DNS" ;;
            "DNS_Server_Exists") echo "Un server DNS con questo nome esiste già" ;;
            "Invalid_IP") echo "non è un indirizzo IP valido" ;;
            "DNS_Added_Success") echo "Nuovo server DNS aggiunto con successo" ;;
            "Edit_DNS_Addresses") echo "Modifica gli indirizzi DNS per" ;;
            "DNS_Updated_Success") echo "Server DNS modificato con successo" ;;
            "Confirm_Delete_DNS") echo "Sei sicuro di voler eliminare il server DNS" ;;
            "DNS_Deleted_Success") echo "Server DNS eliminato con successo" ;;
            "No_Ethernet_Connection") echo "Nessuna connessione Ethernet attiva trovata" ;;
            "DNS_Update_Success") echo "DNS aggiornati con successo a" ;;
            "Network_Restart_Error") echo "Errore durante il riavvio della connessione di rete" ;;
            "DNS_Update_Error") echo "Errore durante l'aggiornamento dei DNS" ;;
            "Custom") echo "Personalizzato" ;;
            "Automatic_DNS") echo "DNS automatico" ;;
            "DNS_Addresses") echo "Indirizzi DNS" ;;
            *) echo "$key" ;;
        esac
    else
        case "$key" in
            "DNS_Management") echo "DNS Management" ;;
            "Change_DNS") echo "Change DNS" ;;
            "Add_DNS_Server") echo "Add new DNS server" ;;
            "Edit_DNS_Server") echo "Edit existing DNS server" ;;
            "Delete_DNS_Server") echo "Delete DNS server" ;;
            "Current_DNS") echo "Current DNS" ;;
            "Select_DNS_Service") echo "Select DNS Service" ;;
            "Custom_DNS") echo "Custom DNS" ;;
            "Enter_DNS_Addresses") echo "Enter DNS addresses separated by spaces" ;;
            "Add_New_DNS_Server") echo "Add new DNS server" ;;
            "Enter_New_DNS_Name") echo "Enter the name of the new DNS server" ;;
            "DNS_Server_Exists") echo "A DNS server with this name already exists" ;;
            "Invalid_IP") echo "is not a valid IP address" ;;
            "DNS_Added_Success") echo "New DNS server added successfully" ;;
            "Edit_DNS_Addresses") echo "Edit DNS addresses for" ;;
            "DNS_Updated_Success") echo "DNS server updated successfully" ;;
            "Confirm_Delete_DNS") echo "Are you sure you want to delete the DNS server" ;;
            "DNS_Deleted_Success") echo "DNS server deleted successfully" ;;
            "No_Ethernet_Connection") echo "No active Ethernet connection found" ;;
            "DNS_Update_Success") echo "DNS updated successfully to" ;;
            "Network_Restart_Error") echo "Error restarting network connection" ;;
            "DNS_Update_Error") echo "Error updating DNS" ;;
            "Custom") echo "Custom" ;;
            "Automatic_DNS") echo "Automatic DNS" ;;
            "DNS_Addresses") echo "DNS Addresses" ;;
            *) echo "$key" ;;
        esac
    fi
}

# Carica i servizi DNS dal file di configurazione o usa i valori predefiniti
load_dns_services() {
    declare -gA dns_services
    echo "Inizio caricamento servizi DNS" >> /tmp/dns_debug.log
    if [[ -f "$CONFIG_FILE" && -s "$CONFIG_FILE" ]]; then
        echo "File di configurazione trovato: $CONFIG_FILE" >> /tmp/dns_debug.log
        source "$CONFIG_FILE"
    else
        echo "File di configurazione non trovato o vuoto. Caricamento valori predefiniti." >> /tmp/dns_debug.log
        dns_services=(
            ["Google"]="8.8.8.8 8.8.4.4"
            ["Cloudflare"]="1.1.1.1 1.0.0.1"
            ["OpenDNS"]="208.67.222.222 208.67.220.220"
            ["Quad9"]="9.9.9.9 149.112.112.112"
            ["AdGuard"]="94.140.14.14 94.140.15.15"
            ["CleanBrowsing"]="185.228.168.168 185.228.169.168"
            ["Comodo"]="8.26.56.26 8.20.247.20"
            ["Verisign"]="64.6.64.6 64.6.65.6"
            ["Alternate"]="76.76.19.19 76.223.122.150"
            ["DNS.WATCH"]="84.200.69.80 84.200.70.40"
        )
        save_dns_services
    fi
    echo "Servizi DNS caricati: ${!dns_services[@]}" >> /tmp/dns_debug.log
    echo "Numero di servizi DNS caricati: ${#dns_services[@]}" >> /tmp/dns_debug.log
}

# Salva i servizi DNS nel file di configurazione
save_dns_services() {
    echo "declare -gA dns_services" > "$CONFIG_FILE"
    for key in "${!dns_services[@]}"; do
        echo "dns_services[\"$key\"]=\"${dns_services[$key]}\"" >> "$CONFIG_FILE"
    done
}

# Funzione per verificare se un indirizzo IP è valido
is_valid_ip() {
    local ip=$1
    local stat=1

    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
    fi
    return $stat
}

# Funzione per trovare il nome del server DNS dato un indirizzo IP
get_dns_name() {
    local ip=$1
    for name in "${!dns_services[@]}"; do
        if [[ ${dns_services[$name]} == *"$ip"* ]]; then
            echo "$name"
            return
        fi
    done
    echo "$(translate Custom)"
}

# Funzione per ottenere i server DNS attuali
get_current_dns() {
    local connection=$(nmcli -t -f NAME,TYPE,DEVICE con show --active | grep ethernet | cut -d: -f1)
    if [ -z "$connection" ]; then
        echo "$(translate No_Ethernet_Connection)"
    else
        local dns=$(nmcli -g ipv4.dns con show "$connection")
        if [ -z "$dns" ]; then
            echo "$(translate Automatic_DNS)"
        else
            local result=""
            IFS=',' read -ra DNS_ARRAY <<< "$dns"
            for ip in "${DNS_ARRAY[@]}"; do
                local name=$(get_dns_name "$ip")
                result+="$name ($ip), "
            done
            echo "${result%, }"
        fi
    fi
}

# Funzione per ottenere la scelta dell'utente tramite UI con barra di stato
get_user_choice() {
    local current_dns=$(get_current_dns)
    local choice=$(zenity --list --title="$(translate DNS_Management)" --column="$(translate Action)" \
        "$(translate Change_DNS)" \
        "$(translate Add_DNS_Server)" \
        "$(translate Edit_DNS_Server)" \
        "$(translate Delete_DNS_Server)" \
        --width=500 --height=400 \
        --text="$(translate Current_DNS): $current_dns")
    echo "$choice"
}

# Funzione per selezionare un servizio DNS
select_dns_service() {
    echo "Inizio selezione servizio DNS" >> /tmp/dns_debug.log
    local current_dns=$(get_current_dns)
    echo "DNS attuali: $current_dns" >> /tmp/dns_debug.log
    local services=()
    echo "Servizi DNS disponibili:" >> /tmp/dns_debug.log
    for name in "${!dns_services[@]}"; do
        services+=("$name" "${dns_services[$name]}")
        echo "  $name: ${dns_services[$name]}" >> /tmp/dns_debug.log
    done
    echo "Numero totale di servizi: ${#services[@]}" >> /tmp/dns_debug.log
    local choice=$(zenity --list --title="$(translate Select_DNS_Service)" \
        --column="$(translate Service)" --column="$(translate DNS_Addresses)" \
        "${services[@]}" \
        --width=500 --height=500 \
        --text="$(translate Current_DNS): $current_dns")
    echo "Scelta dell'utente: $choice" >> /tmp/dns_debug.log
    echo "$choice"
}

# Funzione per ottenere gli indirizzi DNS personalizzati
get_custom_dns() {
    local current_dns=$(get_current_dns)
    local custom_dns=$(zenity --entry --title="$(translate Custom_DNS)" \
        --width=500 \
        --text="$(translate Current_DNS): $current_dns\n\n$(translate Enter_DNS_Addresses):")
    echo "$custom_dns"
}

# Funzione per aggiungere un nuovo server DNS
add_dns_server() {
    local current_dns=$(get_current_dns)
    local name=$(zenity --entry --title="$(translate Add_New_DNS_Server)" \
        --width=500 \
        --text="$(translate Current_DNS): $current_dns\n\n$(translate Enter_New_DNS_Name):")
    if [[ -z "$name" ]]; then
        return
    fi
    if [[ -n "${dns_services[$name]}" ]]; then
        zenity --error --text="$(translate DNS_Server_Exists)" --width=400
        return
    fi
    local addresses=$(get_custom_dns)
    if [[ -z "$addresses" ]]; then
        return
    fi
    for ip in $addresses; do
        if ! is_valid_ip "$ip"; then
            zenity --error --text="'$ip' $(translate Invalid_IP)" --width=400
            return
        fi
    done
    dns_services["$name"]="$addresses"
    save_dns_services
    zenity --info --text="$(translate DNS_Added_Success): '$name'" --width=400
}

# Funzione per modificare un server DNS esistente
edit_dns_server() {
    local current_dns=$(get_current_dns)
    local name=$(select_dns_service)
    if [[ -z "$name" ]]; then
        return
    fi
    local new_addresses=$(zenity --entry --title="$(translate Edit_DNS_Server)" \
        --width=500 \
        --text="$(translate Current_DNS): $current_dns\n\n$(translate Edit_DNS_Addresses) $name:" \
        --entry-text="${dns_services[$name]}")
    if [[ -z "$new_addresses" ]]; then
        return
    fi
    for ip in $new_addresses; do
        if ! is_valid_ip "$ip"; then
            zenity --error --text="'$ip' $(translate Invalid_IP)" --width=400
            return
        fi
    done
    dns_services["$name"]="$new_addresses"
    save_dns_services
    zenity --info --text="$(translate DNS_Updated_Success): '$name'" --width=400
}

# Funzione per eliminare un server DNS
delete_dns_server() {
    local current_dns=$(get_current_dns)
    local name=$(select_dns_service)
    if [[ -z "$name" ]]; then
        return
    fi
    if zenity --question --text="$(translate Current_DNS): $current_dns\n\n$(translate Confirm_Delete_DNS) '$name'?" --width=500; then
        unset "dns_services[$name]"
        save_dns_services
        zenity --info --text="$(translate DNS_Deleted_Success): '$name'" --width=400
    fi
}

# Funzione per aggiornare i DNS
update_dns() {
    local dns_string=$1
    local connection=$(nmcli -t -f NAME,TYPE,DEVICE con show --active | grep ethernet | cut -d: -f1)

    if [ -z "$connection" ]; then
        zenity --error --text="$(translate No_Ethernet_Connection)" --width=400
        exit 1
    fi

    if nmcli con mod "$connection" ipv4.dns "$dns_string" ipv4.ignore-auto-dns yes; then
        if nmcli con up "$connection"; then
            zenity --info --text="$(translate DNS_Update_Success):\n$dns_string" --width=400
        else
            zenity --error --text="$(translate Network_Restart_Error)" --width=400
            exit 1
        fi
    else
        zenity --error --text="$(translate DNS_Update_Error)" --width=400
        exit 1
    fi
}

# Menu principale
main() {
    echo "Inizio esecuzione script" >> /tmp/dns_debug.log
    echo "Contenuto di CONFIG_FILE ($CONFIG_FILE):" >> /tmp/dns_debug.log
    cat "$CONFIG_FILE" >> /tmp/dns_debug.log

    if [[ ! -f "$CONFIG_FILE" || ! -s "$CONFIG_FILE" ]]; then
        echo "File di configurazione non trovato o vuoto. Caricamento servizi DNS." >> /tmp/dns_debug.log
        load_dns_services
    else
        echo "File di configurazione trovato. Caricamento servizi DNS." >> /tmp/dns_debug.log
        source "$CONFIG_FILE"
    fi

    echo "Servizi DNS dopo il caricamento: ${!dns_services[@]}" >> /tmp/dns_debug.log
    echo "Numero di servizi DNS dopo il caricamento: ${#dns_services[@]}" >> /tmp/dns_debug.log

    while true; do
        local choice=$(get_user_choice)
        
        case "$choice" in
            "$(translate Change_DNS)")
                local service=$(select_dns_service)
                if [ -z "$service" ]; then
                    continue
                fi
                local dns_addresses=${dns_services[$service]}
                local dns_string=$(echo $dns_addresses | tr ' ' ',')
                update_dns "$dns_string"
                ;;
            "$(translate Add_DNS_Server)")
                add_dns_server
                ;;
            "$(translate Edit_DNS_Server)")
                edit_dns_server
                ;;
            "$(translate Delete_DNS_Server)")
                delete_dns_server
                ;;
            *)
                exit 0
                ;;
        esac
    done
}

# Esegui il programma principale
main
