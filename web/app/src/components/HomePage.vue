<template>
    <div>
        <div class="row">
            <div class="eventCard col-2" label="Confirm" @click="confirm = true">
                <p class="unselectable">Nouvel évènement</p>
                <p class="add unselectable">+</p>
            </div>

            <div class="eventCard col-2" v-for="event in events" :key="event.id" @click="this.$router.push({name:'eventCard', params:{event_id:event.id}})">
                <button class="delete" @click.stop="deleteevent(event.id)">❌</button>
                <p class="unselectable"><strong>{{ event.libelle }}</strong></p>
                <p class="unselectable">{{ event.description }}</p>
                <p class="unselectable">{{ event.meetingDate }}</p>
                <p class="unselectable">{{ event.meetingHour }}</p>
            </div>
        </div>

        <q-dialog v-model="confirm" persistent>
            <q-card class="modal">
                <q-card-section class="row items-center">
                    <div class="q-ml-sm">
                        <p class="text-h6">Nouvel évènement</p>
                        <q-input v-model="libelle" label="Libellé" autofocus/>
                        <q-input v-model="description" label="Description" />
                        <q-input v-model="meetingDate" label="Date de rendez-vous" />
                        <q-input v-model="meetingHour" label="Heure de rendez-vous" />
                    </div>
                </q-card-section>

                <q-card-actions align="right">
                    <q-btn flat label="Annuler" color="negative" v-close-popup @Click="reset"/>
                    <q-btn flat label="Ajouter" color="primary" v-close-popup @Click="addevent" :disable="libelle.length === 0"/>
                </q-card-actions>
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
            libelle : '',
            description : '',
            events: [
                {id:0, libelle: 'vacances', description:'voyage en corse', meetingDate:'27/07/2022', meetingHour:'7h00', location:'Nancy', members:[],},
                {id:1, libelle: 'travaux', description:'travaux maison', meetingDate:'05/01/2022', meetingHour:'14h00', location:'Nancy', members: [], },
            ],

        }
    },
    
}
</script>

<style scoped>
.eventCard {
    cursor: pointer;
    text-align: center;
    border-radius: 10px;
    background-color: #fff;
    padding: 10px;
    margin: 8px;
    width: 200px !important;
    height: 200px !important;
    box-shadow: rgba(0, 0, 0, 0.15) 0px 3px 3px 0px;
    transition: width 0.2s, height 0.2s, margin 0.2s, padding 0.2s ,filter 0.1s;
}
.eventCard:nth-child(1) {
    background-color: #e0e0e0;
}
.eventCard:hover {
    width: 207px !important;
    height: 207px !important;
    margin: 5px;
    padding: 12px;
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
    margin-top: -45px;
    font-size: 7em;
    color: gray;
}

.modal {
    padding-right: 10px;
    text-align: center;
}

.delete {
    background-color: transparent;
    border: none;
    cursor: pointer;
    filter: hue-rotate(226deg) brightness(120%);
    margin-left: -70px;
    float: right;
}
.delete:hover {
    filter: hue-rotate(1deg);
}

</style>
