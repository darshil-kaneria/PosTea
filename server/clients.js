class Clients {
    constructor() {
        this.clientList = {};
        this.saveClient = this.saveClient.bind(this);
    }

    saveClient(profile_id, client){
        this.clientList[profile_id] = client;
    }
}

module.exports = Clients;