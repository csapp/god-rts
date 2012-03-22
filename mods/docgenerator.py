"""
This script will automatically generate docs for our
Trac code overview.

Run this file from your top-level mod directory
"""

import os

class SpringDocGenerator(object):

    def get_info(self, filepath, doctype):
        info = {}
        reading_info = False
        infile = open(filepath)
        for line in infile:
            if "getinfo" in line.lower():
                reading_info = True
            if not reading_info:
                continue
            line_parts = [part.strip() for part in line.split('=', 1)]
            if len(line_parts) < 2:
                if line.lower().strip() == "end":
                    break
                continue
            name, value = line_parts
            info[name.lower()] = value.strip(",'").strip('"')
        infile.close()
        return info

    def generate_docs(self, dir, doctype):
        outfile = open('%sdocs.txt' % doctype, 'w')
        for f in os.listdir(dir):
            if f.startswith('.') or not f.endswith('.lua'):
                continue
            path = os.path.join(dir, f).replace('\\', '/')
            info = self.get_info(path, doctype)
            if not info:
                continue
            outfile.write("'''%s'''\n" % info["name"])
            
            for key in ["desc", "tickets"]:
                try:
                    outfile.write("* '''%s''': %s\n" % (key.title(), info[key]))
                except KeyError:
                    pass
            outfile.write("* source:src/trunk/mods/%s\n\n" % path)
        outfile.close()

    def generate_gadget_docs(self):
        self.generate_docs("LuaRules/Gadgets", "gadget")

    def generate_power_docs(self):
        self.generate_docs("LuaRules/Classes/Powers", "power")

    def generate_manager_docs(self):
        self.generate_docs("LuaRules/Classes/Managers", "manager")

    def generate_unitmod_docs(self):
        self.generate_docs("LuaRules/Classes/UnitMods", "unitmods")

    def generate_unit_docs(self):
        self.generate_docs("LuaRules/Classes/Units", "unit")

    def generate_widget_docs(self):
        self.generate_docs("LuaUI/Widgets", "widget")

    def generate_all_docs(self):
        self.generate_gadget_docs()
        self.generate_widget_docs()
        self.generate_manager_docs()
        self.generate_power_docs()
        self.generate_unitmod_docs()
        self.generate_unit_docs()


def main():
    SpringDocGenerator().generate_all_docs()

if __name__ == '__main__':
    main()
