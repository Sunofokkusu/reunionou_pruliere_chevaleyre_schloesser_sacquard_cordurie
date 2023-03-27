<template>
    <div class="main">
        <div class="title unselectable white">
            <h1 @click="this.$router.push({name:'HomePage'})">Reunionou</h1>
            <div class="auth" v-if="connected">
                <div>
                    <router-link class="white" to="profile" scope="div"> 
                        {{ name }} <q-icon name="fas fa-user"/>
                    </router-link>
                    /
                    <a href="" class="white" @click="logout"> déconnexion <q-icon name="fas fa-door-open"/></a>
                </div> 
            </div>
            <div v-else class="auth">
                <router-link class="white" to="signUp" scope="div">Connexion/Inscription</router-link>
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
            name: 'pat'
        }
    },
    computed :{
        connected () {
            return this.$store.state.connected
        },
    },
    methods: {
        /**
         * Méthode qui permet de se déconnecter
         * @return, inutilisable
         */
        logout () {
            this.$store.commit("setToken", "")
            this.$store.commit("setConnected", false)
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
    background-color: #3988ff;
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
    background-image: linear-gradient(to right, #ffffff 50%, #8be4ff 50%);
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
