#!/usr/bin/env python3

from nicegui import ui
from pocketbase import PocketBase # Client also works the same

# Initialize PocketBase client
pb = PocketBase('http://db:3000')

@ui.page('/')
def index():
    with ui.header():
        ui.label("Minecraft Coordinate Saver")
    
    ui.label("Welcome to the Minecraft Coordinate Saver!")
    ui.label("This app will help you save and manage your Minecraft coordinates.")
    
    def save_coordinates(x, y, z, comment):
        # Create a new record in the 'coordinates' collection
        data = {
            'x': x,
            'y': y,
            'z': z,
            'comment': comment
        }
        try:
            pb.collection('coordinates').create(data)
            ui.notify("Coordinates saved successfully!", color='green')
        except Exception as e:
            ui.notify(f"Error saving coordinates: {str(e)}", color='red')
    with ui.column().classes('w-full'):
        with ui.row():
            x = ui.number('X Coordinate')
            y = ui.number('Y Coordinate')
            z = ui.number('Z Coordinate')
            comment = ui.input('Comment')
            ui.button('Save Coordinates', on_click=lambda: save_coordinates(x, y, z, comment))
            columns = [
                {'name': 'x', 'label': 'X Coordinate', 'field': 'x', 'required': True, 'align': 'left'},
                {'name': 'y', 'label': 'Y Coordinate', 'field': 'y', 'sortable': True},
                {'name': 'z', 'label': 'Z Coordinate', 'field': 'z', 'sortable': True},
                {'name': 'comment', 'label': 'Comment', 'field': 'comment', 'sortable': True},
            ]           
            
            rows = []
            for result in pb.collection('coordinates').get_full_list(query_params={'expand': 'x,y,z,comment'}):
                    x = result.x
                    y = result.y
                    z = result.z
                    comment = result.comment
                    rows.append({'x': x, 'y':y, 'z': z, 'comment': comment})
                    
            tables = ui.table(columns=columns, rows=rows)
            def msg_callback (data):
                    x = data.record.x
                    y = data.record.y
                    z = data.record.z
                    comment = data.record.comment
                    tables.add_row({'x': x, 'y': y, 'z': z, 'comment': comment})
                    
            pb.collection('coordinates').subscribe(msg_callback)


ui.run(title="My Minecraft Coordinate Saver", favicon="https://www.minecraft.net/favicon.ico")
