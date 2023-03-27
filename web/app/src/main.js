import { createApp } from 'vue'
import App from '@/App.vue'
import router from '@/router/router'
import { Quasar } from 'quasar'
import quasarUserOptions from './quasar-user-options'
import axios from "axios";
import VueAxios from 'vue-axios'
import { createStore } from 'vuex'

// Create a new store instance.
const store = createStore({
    state () {
      return {
        connected: false,
        token: ""
      }
    },
    mutations: {
        setConnected(state, bool) {
            state.connected = bool
        },

        setToken(state, token) {
            state.token = token
        }
    }
  })

createApp(App)
.use(Quasar, quasarUserOptions)
.use(Quasar, quasarUserOptions)
.use(Quasar, quasarUserOptions)
.use(VueAxios, axios)
.use(router)
.use(store)
.mount('#app')