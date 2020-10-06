const { exec } = require("child_process");
const fs = require("fs");

fs.readdir('.', async function (err, fileNames) {
    if (err) {
        return console.log('Unable to scan directory: ' + err);
    }
    let fileTuples = fileNames
        .filter(f => f.indexOf('_tb.vhd') !== -1)
        .map(fTb => {
            return {
                component: fTb.replace('_tb.', '.'),
                testbench: fTb,
            }
        });
    let fails = 0;
    while (fails !== fileTuples.length) {
        let fT = fileTuples.shift();
        let f = fT.component.replace('.vhd', '');
        let fTb = fT.testbench.replace('.vhd', '');
        console.log(fT);
        await new Promise((resolve, reject) => {
            exec('ghdl -s ' + fT.component, err => {
                console.log('1');
                if (err) return reject(err);
                return exec('ghdl -s ' + fT.testbench, err => {
                    console.log('2');
                    if (err) return reject(err);
                    return exec('ghdl -a ' + fT.component, err => {
                        console.log('3');
                        if (err) return reject(err);
                        return exec('ghdl -a ' + fT.testbench, err => {
                            console.log('4');
                            if (err) return reject(err);
                            return exec('ghdl -e ' + fTb, function (err, stdout, stderr) {
                                if (err) return reject(err);
                                if (stderr.indexOf('warning') !== -1) return reject('Este componente depende de outro que ainda não foi compilado');
                                console.log('5');
                                return exec('ghdl -r ' + fTb + ' --stop-time=50000ns --wave=' + f + '.ghw', err => {
                                    console.log('6');
                                    if (err) return reject(err);
                                    return resolve();
                                });
                            });
                        });
                    });
                });
            });
        }).catch((err) => {
            console.log(err);
            fileTuples.push(fT)
        });
    }
});
