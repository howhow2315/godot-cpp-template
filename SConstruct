#!/usr/bin/env python
import os, sys
from methods import print_error


libname = "example"
API_VERSION = "4.7"

# Build profiles can be used to decrease compile times.
# You can either specify "disabled_classes", OR
# explicitly specify "enabled_classes" which disables all other classes.
# Modify the example file as needed and uncomment the line below or
# manually specify the build_profile parameter when running SCons.
# see build_profile.json
USE_BUILD_PROFILE = True 

PROJECT_DIRECTORY = "project"

LIBRARY_DIRECTORY = "library"
SOURCE_DIRECTORY = "source"
GENERATED_DIRECTORY = f"generated"
GENERATED_DOCUMENTS_DIRECTORY = f"generated/documents"
ADDON_DIRECTORY = f"{PROJECT_DIRECTORY}/addons/{libname}"
BIN_DIRECTORY = f"{ADDON_DIRECTORY}/bin"


localEnv = Environment(tools=["default"], PLATFORM="")
if USE_BUILD_PROFILE:
    localEnv["build_profile"] = "build_profile.json"

customs = ["custom.py"]
customs = [os.path.abspath(path) for path in customs]

opts = Variables(customs, ARGUMENTS)
opts.Update(localEnv)

Help(opts.GenerateHelpText(localEnv))

env = localEnv.Clone()

if not (os.path.isdir(f"{LIBRARY_DIRECTORY}/godot-cpp") and os.listdir(f"{LIBRARY_DIRECTORY}/godot-cpp")):
    print_error("""godot-cpp is not available within this folder, as Git submodules haven't been initialized.
Run the following command to download godot-cpp:

    git submodule update --init --recursive""")
    sys.exit(1)

env = SConscript(f"{LIBRARY_DIRECTORY}/godot-cpp/SConstruct", {"api_version": API_VERSION, "env": env, "customs": customs})

env.Append(CPPPATH=[f"{SOURCE_DIRECTORY}/"])
sources = Glob(f"{SOURCE_DIRECTORY}/*.cpp") + Glob(f"{SOURCE_DIRECTORY}/*/*.cpp") # also include subfolders

# include document data
if env["target"] in ["editor", "template_debug"]:
    try:
        doc_data = env.GodotCPPDocData(f"{GENERATED_DOCUMENTS_DIRECTORY}/doc_data.gen.cpp", source=Glob("doc_classes/*.xml"))
        sources.append(doc_data)
    except AttributeError:
        print("Not including class reference as we're targeting a pre-4.3 baseline.")

# .dev doesn't inhibit compatibility, so we don't need to key it.
# .universal just means "compatible with all relevant arches" so we don't need to key it.
suffix = env['suffix'].replace(".dev", "").replace(".universal", "")
lib_filename = f"{env.subst('$SHLIBPREFIX')}{libname}{suffix}{env.subst('$SHLIBSUFFIX')}"

library = env.SharedLibrary(
    f"bin/{env['platform']}/{lib_filename}",
    source=sources,
)

BIN_SUBDIRECTORY = env["platform"]
# BIN_SUBDIRECTORY = f"{env["platform"]}.{env['arch']}" # if you use this make sure to update the .gdextension
copy = env.Install(f"{ADDON_DIRECTORY}/bin/{BIN_SUBDIRECTORY}/", library)

default_args = [library, copy]
Default(*default_args)
