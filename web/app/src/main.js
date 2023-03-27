import { createApp } from 'vue'
import App from '@/App.vue'
import router from '@/router/router'
import { Quasar } from 'quasar'
import quasarUserOptions from './quasar-user-options'
import axios from "axios";
import VueAxios from 'vue-axios'

createApp(App).use(Quasar, quasarUserOptions).use(Quasar, quasarUserOptions).use(VueAxios, axios).use(router).mount('#app')