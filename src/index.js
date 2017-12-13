(function (factory) {
    if (typeof module === "object" && typeof module.exports === "object") {
        var v = factory(require, exports);
        if (v !== undefined) module.exports = v;
    }
    else if (typeof define === "function" && define.amd) {
        define(["require", "exports"], factory);
    }
})(function (require, exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    let path = require("path");
    let fs = require("fs-extra");
    let os = require('os');
    let iconv = require('iconv-lite');
    class NodeInno {
        constructor() {
            this.spawn = require('child_process').spawn;
            this.exec = require('child_process').exec;
            this.colorRed = '\x1b[41m%s\x1b[0m';
            this.colorGreen = '\x1b[32m%s\x1b[0m';
            this.colorYellow = '\x1B[33m%s\x1B[39m';
        }
        preprocessScript() {
            let packPath = path.join(process.cwd(), "package.json");
            let pakage;
            try {
                pakage = require(packPath);
            }
            catch (e) {
                console.log(this.colorRed, `error: ${packPath} not found.`);
                return false;
            }
            if (pakage["node-inno-build"] && typeof pakage["node-inno-build"] != "string") {
                console.log(this.colorRed, `error: "node-inno-buildjson" must be an object`);
                return false;
            }
            let nodeInnoBase = __dirname;
            let targetJson, targetJsonPath = path.join(pakage["node-inno-build"], "build.json") || "build/build.json";
            try {
                targetJson = fs.readJsonSync(path.join(process.cwd(), targetJsonPath), { throws: false });
            }
            catch (e) {
                console.log(this.colorRed, `error: ${path.join(process.cwd(), targetJsonPath)} not found.`);
            }
            let defaultJson = fs.readJsonSync(path.join(nodeInnoBase, "template/build.json"), { throws: false });
            let defaultJsonString = fs.readFileSync(path.join(nodeInnoBase, "template/build.json"));
            if (!targetJson) {
                console.log(this.colorRed, 'cannot find file : ./build/build.json');
                return false;
            }
            let tip = "\n ↓ ↓ ↓ ↓ ↓  Please refer to the following template ↓ ↓ ↓ ↓ ↓\n";
            if (!targetJson.app || !targetJson.app.exe) {
                console.log(this.colorRed, 'build.json => "app.exe" required');
                console.log(this.colorYellow, tip);
                console.log(this.colorYellow, defaultJsonString);
                return false;
            }
            if (!targetJson.app || !targetJson.app.package) {
                console.log(this.colorRed, 'build.json => "app.package" required');
                console.log(this.colorYellow, tip);
                console.log(this.colorYellow, defaultJsonString);
                return false;
            }
            let buildTempRoot = path.join(os.homedir(), "Desktop/node-inno");
            console.log(defaultJson);
            targetJson = require('extend')(true, defaultJson, targetJson);
            targetJson.app.name = targetJson.app.name || pakage.name;
            targetJson.app.version = targetJson.app.version || pakage.version;
            targetJson.app.exe = path.join(process.cwd(), targetJson.app.exe);
            targetJson.installDetail.installerOutputDir = path.join(process.cwd(), targetJson.installDetail.installerOutputDir || `${pakage.name}-${pakage.version}.exe`);
            targetJson.app.package = path.join(process.cwd(), targetJson.app.package);
            console.log(targetJson);
            try {
                fs.ensureDirSync(buildTempRoot);
                fs.copySync(path.join(nodeInnoBase, "template/package"), buildTempRoot);
            }
            catch (e) {
                console.error(this.colorRed, e);
                return false;
            }
            fs.copySync(path.join(process.cwd(), pakage["node-inno-build"]), buildTempRoot);
            if (!targetJson.buildScript) {
                let template = require('art-template');
                try {
                    fs.copySync(path.join(nodeInnoBase, "template/package"), buildTempRoot);
                    let scripts = [
                        "common.iss",
                        "config.iss",
                        "const.iss",
                        "installDetail.iss",
                        "installFinish.iss",
                        "installProgressBar.iss",
                        "resetMainWindow.iss"
                    ];
                    let renderer, tmp, encoding = targetJson.ui.encoding || "utf8";
                    fs.ensureDirSync(path.join(buildTempRoot, "includes"));
                    scripts.forEach((s, i) => {
                        tmp = fs.readFileSync(path.join(nodeInnoBase, "template/includes", s), 'utf-8');
                        renderer = template.compile(tmp, {
                            escape: false
                        });
                        fs.outputFileSync(path.join(buildTempRoot, "includes", s), iconv.encode(renderer(targetJson), encoding));
                    });
                    fs.copySync(path.join(nodeInnoBase, "template/", "build.iss"), path.join(buildTempRoot, "build.iss"));
                    targetJson.buildScript = targetJson.buildScript ? path.join(process.cwd(), targetJson.buildScript) : path.join(buildTempRoot, "build.iss");
                    if (!fs.existsSync(targetJson.buildScript)) {
                        console.error(this.colorRed, `build script file "${targetJson.buildScript}" not found`);
                        return false;
                    }
                    this.config = targetJson;
                    return true;
                }
                catch (e) {
                    console.error(this.colorRed, e);
                    return false;
                }
            }
            return true;
        }
        build() {
            if (!this.preprocessScript()) {
                console.log(this.colorRed, 'node-inno config error!');
                return false;
            }
            let innoPath = path.join(__dirname, 'Inno_Setup_5/ISCC.exe');
            let buildProcess = this.spawn(innoPath, [this.config.buildScript]);
            buildProcess.stdout.on('data', (data) => {
            });
            buildProcess.stderr.on('data', (data) => {
            });
            buildProcess.on('close', (code) => {
            });
            buildProcess.on('exit', (code) => {
                if (code === 0) {
                    console.log(this.colorGreen, `√ child process exited with code ${code} √`);
                }
                else {
                    console.log(this.colorRed, `× child process exited with code ${code} ×`);
                }
            });
        }
    }
    exports.NodeInno = NodeInno;
});
