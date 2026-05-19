function verifyKey(key) {

    // =================================================
    // LOAD DATABASE
    // =================================================

    const data = loadKeys();

    // =================================================
    // INVALID KEY
    // =================================================

    if (!data.keys[key]) {

        console.log(
            `INVALID KEY: ${key}`
        );

        return false;
    }

    // =================================================
    // MASTER KEY CHECK
    // =================================================

    if (data.keys[key].master === true) {

        console.log(
            `MASTER KEY USED: ${key}`
        );

        return true;
    }

    // =================================================
    // ALREADY USED
    // =================================================

    if (data.keys[key].used) {

        console.log(
            `USED KEY: ${key}`
        );

        return false;
    }

    // =================================================
    // MARK USED
    // =================================================

    data.keys[key].used = true;

    saveKeys(data);

    console.log(
        `VALID KEY USED: ${key}`
    );

    return true;
}
