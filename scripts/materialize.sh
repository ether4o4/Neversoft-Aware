#!/usr/bin/env bash
set -euo pipefail

mkdir -p app/src/main/assets app/src/main/java/com/neversoft/aware
base64 -d encoded/app_js.b64 > app/src/main/assets/app.js
cat encoded/MainActivity.part*.b64 | base64 -d > app/src/main/java/com/neversoft/aware/MainActivity.java

python - <<'PY'
from pathlib import Path

java = Path('app/src/main/java/com/neversoft/aware/MainActivity.java')
source = java.read_text()
source = source.replace(
'''        if (checkSelfPermission("com.termux.permission.RUN_COMMAND") != PackageManager.PERMISSION_GRANTED) {
            pendingTermuxCommand = command;
            requestPermissions(new String[]{"com.termux.permission.RUN_COMMAND"}, REQ_TERMUX_PERMISSION);
            return;
        }
''',
'''        String packageName = preferences.getString("termuxPackage", DEFAULT_TERMUX_PACKAGE);
        String permission = packageName + ".permission.RUN_COMMAND";
        if (checkSelfPermission(permission) != PackageManager.PERMISSION_GRANTED) {
            pendingTermuxCommand = command;
            requestPermissions(new String[]{permission}, REQ_TERMUX_PERMISSION);
            return;
        }
''')
source = source.replace(
'''            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                startForegroundService(intent);
            } else {
                startService(intent);
            }
''',
'''            startService(intent);
''')
source = source.replace(
'''            result.put("termuxPermission", checkSelfPermission("com.termux.permission.RUN_COMMAND") == PackageManager.PERMISSION_GRANTED);
''',
'''            result.put("termuxPermission", checkSelfPermission(termuxPackage + ".permission.RUN_COMMAND") == PackageManager.PERMISSION_GRANTED);
''')
lines = source.splitlines()
for index, line in enumerate(lines):
    if 'result.put("urls"' in line:
        lines[index] = '        result.put("urls", matchesArray(text, Pattern.compile("https?://\\\\S+", Pattern.CASE_INSENSITIVE), 100));'
source = '\n'.join(lines) + '\n'
source = source.replace('writeText(info, data.toString(2));', 'writeText(info, data.toString());')
java.write_text(source)

manifest = Path('app/src/main/AndroidManifest.xml')
xml = manifest.read_text()
if 'com.neversoft.shell.permission.RUN_COMMAND' not in xml:
    xml = xml.replace(
        '<uses-permission android:name="com.termux.permission.RUN_COMMAND" />',
        '<uses-permission android:name="com.termux.permission.RUN_COMMAND" />\n    <uses-permission android:name="com.neversoft.shell.permission.RUN_COMMAND" />'
    )
manifest.write_text(xml)
PY
