#%%
from asyncio import StreamReader,StreamWriter
#%%

INFO_TYPE={'SERVER_READY':'0','CLIENT_READY':'1','REWARD':'2','CHOICE':'3','RUN_OVER':'4','SUBJECT_ID':'5','START_SINGLE':'6','START_MULTI':'7','QUORUM':'8','N_PROPOSE':'9','TRAVEL':'10','RT':'11'}

async def read_msg(Stream:StreamReader,required_round:int):
    #check if the round and info_type is right
    sub_id=await Stream.readline()
    sub_id=sub_id.decode()[0:-1]
    info_type=await Stream.readline()
    info_type=info_type.decode()[0:-1]#delete /n
    round_in_game=await Stream.readline()
    round_in_game=round_in_game.decode()[0:-1]
    data=await Stream.readline()
    data=data.decode()[0:-1]
    if str(round_in_game)!=str(required_round):
        print(round_in_game)
        print(required_round)
        print('round_error')
        data='connection_error'
    data=[sub_id,info_type,data]
    return data

async def send_msg(Stream:StreamWriter,sub_id:int,info_type:int,n_round_in_game:int,data:str):
    message=[str(sub_id).encode()+'\n'.encode(),str(info_type).encode()+'\n'.encode(),str(n_round_in_game).encode()+'\n'.encode(),data.encode()+'\n'.encode()]
    Stream.writelines(message)
    await Stream.drain()

# %%
