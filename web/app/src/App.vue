<template>
    <div class="main">
        <div class="title unselectable white">
            <h1 @click="this.$router.push({name:'HomePage'})">Reunionou</h1>
            <div class="auth" v-if="connected">
                <div>
                        <span @click="this.$router.push({name:'ProfileUser'})">{{ name }} <q-icon name="fas fa-user"/></span>
                    /
                    <span @click="logout"> déconnexion <q-icon name="fas fa-door-open"/></span>
                </div> 
            </div>
            <div v-else class="auth">
                <span @click="this.$router.push({name:'signIn'})">Connexion/Inscription</span> 
            </div>
        </div>   
        <router-view/>
    </div>
</template>

<script>

export default {
  name: 'LayoutDefault',
    data () {
        return {

        }
    },
    computed :{
        connected () {
            return this.$store.state.connected
        },
        name(){
            return this.$store.state.name;
        }
    },
    methods: {
        /**
         * Méthode qui permet de se déconnecter
         * @return, inutilisable
         */
        logout () {
            this.$store.commit("setToken", "");
            this.$store.commit("setConnected", false);
            this.$store.commit("setName", "");
            this.$router.push({name:'HomePage'});
        }
    }
}
</script>

<style>

body {
    background-color: #f6f4f4;
}

.main {
    padding: 10px;
    width: 100%;
    height: 100%;
}

.title{
    margin: -50px -10px -30px -10px;
    padding: 15px 10px 5px 20px;
    border-radius: 0 0 15px 15px;
    background-color: #34495e;
    display: flex;
    align-items: center;
}

.auth{
    margin-left: auto;
    margin-right: 20px;
    font-size: 1.2em;
    cursor: pointer;
}

.white{
    color: white;
}

.title>h1{
    font-size: 4em;
    max-width: 490px;
    height: 90px;
    line-height: 90px;
    cursor: pointer;
    display: block;
    background-size: 200% 100%;
    background-image: linear-gradient(to right, #ffffff 50%, #4CAF50 50%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    transition: background-position 0.5s;
}
.title>h1:hover{
    background-position: -100% 0;
}

.unselectable {
    -moz-user-select: none;
    -khtml-user-select: none;
    -webkit-user-select: none;
    -ms-user-select: none;
    user-select: none;
}

::-webkit-scrollbar {
    width: 10px;
}

::-webkit-scrollbar-thumb {
    background: #666;
    border-radius: 20px;
}

::-webkit-scrollbar-track {
    background: #cccccc;

}
</style>
