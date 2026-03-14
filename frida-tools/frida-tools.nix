{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools,
  pygments,
  prompt-toolkit,
  colorama,
  frida-python,
  websockets,
}:

buildPythonPackage rec {
  pname = "frida-tools";
  version = "13.7.1";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "frida-tools";
    hash = "sha256-c0Gq1ep75WAvTGIj4c7xSy0NjCGK5wrRPYzeYyFHDgU=";
  };

  build-system = [
    setuptools
  ];

  pythonRelaxDeps = [
    "frida"
    "websockets"
  ];

  dependencies = [
    pygments
    prompt-toolkit
    colorama
    frida-python
    websockets
  ];

  meta = {
    description = "Dynamic instrumentation toolkit for developers, reverse-engineers, and security researchers (client tools)";
    homepage = "https://www.frida.re/";
    maintainers = with lib.maintainers; [ s1341 ];
    license = with lib.licenses; [
      lgpl2Plus
      wxWindowsException31
    ];
  };
}
