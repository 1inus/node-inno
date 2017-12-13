import { encode } from "punycode";

let path = require("path");
let fs = require("fs-extra");
let os = require('os');
let iconv = require('iconv-lite');

export class NodeInno {
	private spawn = require('child_process').spawn;
	private exec = 	require('child_process').exec;
	private config:any;
	private colorRed:string  = '\x1b[41m%s\x1b[0m';
	private colorGreen:string = '\x1b[32m%s\x1b[0m';
	private colorYellow:string = '\x1B[33m%s\x1B[39m';

	constructor() {}

	/**
	 * 
	 */
	private preprocessScript(){
		let packPath = path.join(process.cwd(), "package.json");
		let pakage: any;
		try {
			pakage = require(packPath);
		} catch (e) {
			console.log(this.colorRed, `error: ${packPath} not found.`);
			return false;
		}

		if (pakage["node-inno-build"] && typeof pakage["node-inno-build"] != "string") {
			console.log(this.colorRed, `error: "node-inno-buildjson" must be an object`);
			return false;
		}

		/*  */
		let nodeInnoBase = __dirname;
		let targetJson:any, targetJsonPath = path.join(pakage["node-inno-build"], "build.json") || "build/build.json";
		try{
			targetJson = fs.readJsonSync(path.join(process.cwd(), targetJsonPath), { throws: false });
		} catch(e){
			console.log(this.colorRed, `error: ${path.join(process.cwd(), targetJsonPath)} not found.`);
		}

		let defaultJson = fs.readJsonSync(path.join(nodeInnoBase, "template/build.json"), { throws: false });
		let defaultJsonString = fs.readFileSync(path.join(nodeInnoBase, "template/build.json"));

		if(!targetJson){
			console.log(this.colorRed, 'cannot find file : ./build/build.json');
			return false;
		}

		let tip = "\n ↓ ↓ ↓ ↓ ↓  Please refer to the following template ↓ ↓ ↓ ↓ ↓\n";
		if(!targetJson.app || !targetJson.app.exe){
			console.log(this.colorRed, 'build.json => "app.exe" required');
			console.log(this.colorYellow, tip);
			console.log(this.colorYellow, defaultJsonString);
			return false;
		}

		if(!targetJson.app || !targetJson.app.package){
			console.log(this.colorRed, 'build.json => "app.package" required');
			console.log(this.colorYellow, tip);
			console.log(this.colorYellow, defaultJsonString);
			return false;
		}

		//let buildRoot = path.join(os.tmpdir(), "node-inno");

		let buildTempRoot = path.join(os.homedir(), "Desktop/node-inno");

		console.log(defaultJson);

		targetJson = require('extend')(true, defaultJson, targetJson);

		/**
		 * dir config
		 */
		targetJson.app.name = targetJson.app.name || pakage.name;
		targetJson.app.version = targetJson.app.version || pakage.version;
		targetJson.app.exe = path.join(process.cwd(), targetJson.app.exe);
		targetJson.installDetail.installerOutputDir = path.join(process.cwd(), targetJson.installDetail.installerOutputDir || `${pakage.name}-${pakage.version}.exe`);
		targetJson.app.package = path.join(process.cwd(), targetJson.app.package);

		console.log(targetJson);

		/* copy resources to temp */
		try{
			fs.ensureDirSync(buildTempRoot);
			fs.copySync(path.join(nodeInnoBase, "template/package"), buildTempRoot);
		} catch(e){
			console.error(this.colorRed, e);
			return false;
		}

		fs.copySync(path.join(process.cwd(), pakage["node-inno-build"]), buildTempRoot);

		if(!targetJson.buildScript){
			/* compile script template*/
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
	
				let renderer, tmp,  encoding = targetJson.ui.encoding || "utf8";
				fs.ensureDirSync(path.join(buildTempRoot, "includes"));
				scripts.forEach((s, i)=>{
					tmp = fs.readFileSync(path.join(nodeInnoBase, "template/includes", s), 'utf-8');
					renderer = template.compile(tmp, {
						escape: false
					});
					fs.outputFileSync(path.join(buildTempRoot, "includes", s), iconv.encode(renderer(targetJson), encoding));
				});
	
				/* copy main script to temp dir */
				fs.copySync(path.join(nodeInnoBase, "template/", "build.iss"), path.join(buildTempRoot, "build.iss"));
	
	
				/* default build script */
				targetJson.buildScript = targetJson.buildScript ? path.join(process.cwd(), targetJson.buildScript) : path.join(buildTempRoot, "build.iss");
				if(!fs.existsSync(targetJson.buildScript)){
					console.error(this.colorRed, `build script file "${targetJson.buildScript}" not found`);
					return false;
				}
	
				this.config = targetJson;
	
				return true;
			} catch (e) {
				console.error(this.colorRed, e);
				return false;
			}
		}

		return true;
	}

	/**
	 * 
	 */
	public build() {
		if(!this.preprocessScript()){
			console.log(this.colorRed, 'node-inno config error!');
			return false;
		}

		/* inno路径 */
		let innoPath = path.join(__dirname, 'Inno_Setup_5/ISCC.exe');
		let buildProcess = this.spawn(innoPath, [this.config.buildScript]);
		
		/* 开始编译 */
		buildProcess.stdout.on('data', (data: any) => {
			//console.log(this.colorGreen, data);
		});

		buildProcess.stderr.on('data', (data: any) => {
			//console.log(this.colorRed, data);
		});

		buildProcess.on('close', (code: any) => {
			//console.log(this.colorGreen, `child process exited with code ${code}`);
		});

		buildProcess.on('exit', (code: any) => {
			if(code === 0){
				console.log(this.colorGreen, `√ child process exited with code ${code} √`);
			} else {
				console.log(this.colorRed, `× child process exited with code ${code} ×`);
			}
		});
	}
}