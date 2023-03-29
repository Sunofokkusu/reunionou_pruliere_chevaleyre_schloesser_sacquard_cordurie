<template>
    <div>
        <div v-if="connected" class="row">
            <div class="eventCard col-2" label="Confirm" @click="confirm = true">
                <p class="unselectable">Nouvel évènement</p>
                <p class="add unselectable">+</p>
            </div>
          

            <div class="eventCard col-2" v-for="event in events" :key="event.id" @click="this.$router.push({name:'eventCard', params:{event_token:event.token}})">
                <p class="unselectable">{{ event.title }}</p>
                <p class="unselectable">{{ event.description }}</p>
                <p class="unselectable">{{ new Date(event.meetingDate).toLocaleDateString() }}</p>
                <p class="unselectable">{{ new Date(event.meetingDate).getHours()-2 }}h{{ new Date(event.meetingDate).getMinutes() }}</p>
                <p class="unselectable">{{ event.adress }}</p>
            </div>
        </div>

        <div v-else class="row">
            <div class="col-12 eventCard">
                <p>Vous devez être connecté pour accéder aux évènements</p>
            </div>
        </div>

        <q-dialog v-model="confirm" persistent>
            <q-card class="modal">
                <q-card-section class="row items-center">
                    <div class="q-ml-sm">
                        <p class="text-h6">Nouvel évènement</p>
                        <q-input v-model="title" label="Libellé*" autofocus/>
                        <q-input v-model="description" label="Description" />
                        <q-input v-model="meetingDate" type="date" label="Date de rendez-vous*" />
                        <q-input v-model="meetingHour" type="time" label="Heure de rendez-vous*" />
                        <q-input v-model="adress" label="Lieu de rendez-vous*" />
                    </div>
                </q-card-section>

                <q-card-actions align="right">
                    <q-btn flat label="Annuler" color="negative" v-close-popup @Click="reset"/>
                    <q-btn flat label="Ajouter" color="primary" v-close-popup @Click="addevent" :disable="verifEmpty" />
                </q-card-actions>

                <q-card-section v-if="errored" class="items-center">
                    <div class="q-ml-sm red">Veuillez renseigner tous les champs obligatoires</div>
                </q-card-section>
            </q-card>
           
        </q-dialog>
    </div>
</template>

<script>
export default {
    name: 'HomePage',
    data(){
        return {
            confirm : false,
            title : '',
            description : '',
            meetingDate : '',
            meetingHour : '',
            adress : '',
            lat : 0,
            lng : 0,
            events: [
                {token: '', title:'vacances', description:'voyage en corse', meetingDate:'2022-07-27T07:00:00', adress:'Nancy'},
                {token: '', title:'travaux', description:'travaux maison', meetingDate:'2022-05-06T14:00:00', adress:'Nancy'},
            ],
            errored: false,
        }
    },
    mounted() {
        //récupération des évènements enregistrés en local si il y en a
        if(localStorage.getItem('events')){
            this.events = JSON.parse(localStorage.getItem('events'))
        } else {
            localStorage.setItem('events', JSON.stringify(this.events))
        }
    },
    computed :{
        connected () {
            return this.$store.state.connected
        },

        /**
         * vérifie si les champs obligatoires sont remplis
         * @returns {boolean} true si les champs obligatoires sont remplis, false sinon
         */
        verifEmpty () {
            if(this.title !== '' && this.meetingDate !== '' && this.meetingHour !== '' && this.adress !== ''){
                return false
            } else {
                return true
            }
        }
    },
    methods: {
        /**
         * permet d'ajouter un evenement
         * @return inutilisable
         */
        async addevent() {
            if(this.title !== '' && this.meetingDate !== '' && this.meetingHour !== '' && this.adress !== ''){
                this.errored = false

                this.meetingDate = this.meetingDate + 'T' + this.meetingHour + ':00'     

                try {
                    await this.getadress(this.adress)
                    console.log(this.lat)
                    this.axios.defaults.headers.post['Authorization'] = this.$store.state.token;               
                    let response = await this.axios.post("http://localhost:80/event", {
                        title: this.title,
                        description: this.description,
                        date: this.meetingDate,
                        adress: this.adress,
                        lat: this.lat,
                        long: this.lng,
                    })

                    this.events.push({token: response.data.token, title: this.title, description: this.description, meetingDate: this.meetingDate, meetingHour: this.meetingHour, adress: this.adress})
                    localStorage.setItem('events', JSON.stringify(this.events))

                    this.reset()
                } catch (error) {
                    console.log(error)
                }

            } else {
                this.errored = true
            }
        },

        /**
         * récupère la longitude et la latitude d'une adresse via l'api adresse.data.gouv.fr
         * @param {String} adress
         */
        async getadress(adress) {
            try {
                let response = await this.axios.get("https://api-adresse.data.gouv.fr/search/?q="+encodeURI(adress))
                this.lat = response.data.features[0].geometry.coordinates[1]
                this.lng = response.data.features[0].geometry.coordinates[0]
            } catch (error) {
                console.log(error)
            }
        },

        /**
         * vide les champs du formulaire
         * @return inutilisable
         */
        reset() {
            this.title = ''
            this.description = ''
            this.meetingDate = ''
            this.meetingHour = ''
            this.adress = ''
        },
        }
    }
</script>

<style scoped>
.eventCard {
    cursor: pointer;
    text-align: center;
    border-radius: 10px;
    background-color: #fff;
    margin: 8px;
    width: 200px !important;
    height: 200px !important;
    box-shadow: rgba(0, 0, 0, 0.15) 0px 3px 3px 0px;
    transition: width 0.2s, height 0.2s, margin 0.2s, padding 0.2s ,filter 0.1s;
}
.eventCard>p {
    margin-top: -10px;
}
.eventCard:nth-child(1) {
    background-color: #e0e0e0;
}
.eventCard:hover {
    width: 207px !important;
    height: 207px !important;
    margin: 5px;
    filter: brightness(96%) ;
}
.eventCard:active {
    filter: brightness(90%);
}
.eventCard:nth-child(1):hover>.add {
    color: #39c3ff;
}
.eventCard>p:first-of-type {
    margin-top: 30px;
    font-size: 1.5em;
}

.add {
    margin-top: -45px !important;
    font-size: 7em;
    color: gray;
}

.modal {
    padding-right: 10px;
    text-align: center;
}

.red {
    color: red;
}

</style>
