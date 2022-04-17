# night-light

## Usage
```
sudo wget -P /usr/local/bin/ https://raw.githubusercontent.com/thanospan/scripts/main/night-light/night-light.sh
sudo chmod +x /usr/local/bin/night-light.sh
night-light.sh [OPTIONS]

Options:
  --help
  --status
  --on
  --off
  --temp       Range: [1700, 4700]
  --from       Range: [00:00, 23:59]
  --to         Range: [00:00, 23:59]
  
Example:
night-light.sh --from 19:00 --to 06:00 --temp 3200 --on
```
