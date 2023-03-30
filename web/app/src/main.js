import { createApp } from "vue";
import App from "@/App.vue";
import router from "@/router/router";
import { Quasar } from "quasar";
import quasarUserOptions from "./quasar-user-options";
import axios from "axios";
import VueAxios from "vue-axios";
import { createStore } from "vuex";
import createPersistedState from "vuex-persistedstate";

// Create a new store instance.
const store = createStore({
  plugins: [createPersistedState()],
  state() {
    return {
      connected: false,
      token: "",
      name: "",
      base_url: "http://localhost:80"
    };
  },
  mutations: {
    /**
     * Permet de changer la valeur du store "connected"
     * @param {*} state nom de la fonction
     * @param {*} bool nouvelle valeur du state connected
     */
    setConnected(state, bool) {
      state.connected = bool;
    },
    /**
     * Permet de changer la valeur du store "token"
     * @param {*} state nom de la fonction
     * @param {*} token nouvelle valeur du state token
     */
    setToken(state, token) {
      state.token = token;
    },
    /**
     * Permet de changer la valeur du store "name"
     * @param {*} state nom de la fonction
     * @param {*} name nouvelle valeur du state name
     */
    setName(state, name) {
      state.name = name;
    },
  },
});

createApp(App)
  .use(Quasar, quasarUserOptions)
  .use(Quasar, quasarUserOptions)
  .use(Quasar, quasarUserOptions)
  .use(VueAxios, axios)
  .use(router)
  .use(store)
  .mount("#app");
