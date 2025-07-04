# Internet Access Control

A powerful Windows batch script that gives you complete control over your computer's internet access. Block all internet connections and create a whitelist of approved applications - perfect for productivity, focus, parental controls, or security isolation.

## Features

- **Complete Internet Lockdown** - Block ALL internet access including Windows system processes
- **Selective App Control** - Allow only specific applications to access the internet
- **Persistent Settings** - Rules survive computer restarts
- **Easy Management** - Simple menu-driven interface
- **Quick Recovery** - One-click restore to normal internet access
- **Windows Services Mode** - Block apps but keep essential Windows functions
- **Desktop Shortcut** - Create quick access for emergency restoration

## Use Cases

### **Productivity & Focus**
- Block distracting websites and apps during work/study sessions
- Create a distraction-free environment for deep work
- Allow only work-related applications (IDE, email, specific browsers)

### **Parental Controls**
- Restrict children's internet access to approved educational apps
- Block games and social media during homework time
- Create safe computing environments for kids

### **Security & Privacy**
- Isolate your computer from the internet for sensitive work
- Prevent unauthorized data transmission
- Create air-gapped environments for malware analysis
- Block potential spyware and tracking

### **Testing & Development**
- Test offline functionality of applications
- Simulate network-disconnected environments
- Prevent accidental data uploads during development

## Requirements

- Windows 10/11 (any edition)
- Administrator privileges
- Windows Firewall enabled (built-in to Windows)

## Installation

1. Download the `internet_control.bat` file
2. Save it to a memorable location (Desktop recommended)
3. Right-click the file and select **"Run as administrator"**
4. Follow the on-screen menu

## Usage

### Menu Options

1. **Block ALL internet access** - Complete lockdown including Windows system
2. **Add application to allowed list** - Whitelist specific apps
3. **Remove application from allowed list** - Remove apps from whitelist
4. **Restore normal internet access** - Complete restoration to default settings
5. **View current firewall rules** - See all active rules
6. **Allow essential Windows services only** - Block apps but keep Windows functional
7. **Create desktop shortcut** - Quick access for future use

### Quick Start Guide

```batch
# 1. Run the script as administrator
Right-click internet_control.bat → "Run as administrator"

# 2. Choose blocking mode
Option 1: Complete lockdown (most restrictive)
Option 6: Windows services only (recommended for daily use)

# 3. Add your essential apps
Option 2: Add applications like browsers, email clients, etc.

# 4. When done, restore normal access
Option 4: Restore normal internet access
```

## Examples

### Example 1: Productivity Setup
```
1. Choose Option 6 (Windows services only)
2. Add your work browser: C:\Program Files\Firefox\firefox.exe
3. Add your email client: C:\Program Files\Outlook\outlook.exe
4. Add your IDE: C:\Program Files\VSCode\code.exe
Result: Only work-related apps can access internet
```

### Example 2: Study Mode
```
1. Choose Option 1 (Complete lockdown)
2. Add educational apps only
3. Block all entertainment and social media
Result: Distraction-free learning environment
```

### Example 3: Security Testing
```
1. Choose Option 1 (Complete lockdown)
2. No apps added to whitelist
3. Test malware in isolated environment
Result: Complete network isolation
```

## Important Notes

### Persistence
- **Settings survive reboots** - Your computer will start with internet blocked
- Keep the script file accessible for making changes
- Use Option 7 to create a desktop shortcut for quick access

### Recovery Options
If you lose access to the script:
- Windows Key + R → `firewall.cpl` → Restore defaults
- Control Panel → Windows Defender Firewall → Restore defaults
- Boot into Safe Mode (firewall rules don't apply)
- Use System Restore

### Potential Issues
When using complete lockdown (Option 1):
- Windows Updates won't work
- System time won't sync
- Microsoft Store disabled
- OneDrive sync stops
- Some Windows features may malfunction

## Technical Details

### How It Works
- Uses Windows built-in firewall (netsh advfirewall)
- Creates outbound blocking rules
- Manages application-specific exceptions
- Stores rules in Windows registry (persistent)

### Firewall Rules Created
```batch
# Block all outbound traffic
netsh advfirewall set allprofiles firewallpolicy blockinbound,blockoutbound

# Add application exception
netsh advfirewall firewall add rule name="Allow AppName" dir=out action=allow program="C:\path\to\app.exe"
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. Some ideas for improvements:

- GUI version using PowerShell or C#
- Scheduled blocking/unblocking
- Profile management (work, study, gaming profiles)
- Network monitoring and logging
- Integration with task scheduler

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

If this script helped you, please give it a star! 

For issues or questions:
- Open an issue on GitHub
- Check the troubleshooting section above
- Review Windows Firewall documentation

## Changelog

### v1.0
- Initial release
- Basic blocking and allowing functionality
- Menu-driven interface
- Desktop shortcut creation

---

**Disclaimer**: This script modifies Windows Firewall settings. Always test in a safe environment first. The authors are not responsible for any system issues or data loss. Use at your own risk.