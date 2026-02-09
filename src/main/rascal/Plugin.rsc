module Plugin

import IO;
import ParseTree;
import util::Reflective;
import util::IDEServices;
import util::LanguageServer;
import Relation;

import Syntax;
import Generator1;
import Generator2;
import Generator3;

PathConfig pcfg = getProjectPathConfig(|project://rascaldsl|);
Language tdslLang = language(pcfg, "TDSL", "tdsl", "Plugin", "contribs");

data Command = gen1(Planning p)
	     | gen2(Planning p)
	     | gen3(Planning p);

set[LanguageService] contribs() = {
    parser(start[Planning] (str program, loc src) {
        return parse(#start[Planning], program, src);
    }),
    lenses(rel[loc src, Command lens] (start[Planning] p) {
        return {
            <p.src, gen1(p.top, title="Generate text file")>,
            <p.src, gen2(p.top, title="Text generator2")>,
            <p.src, gen3(p.top, title="Text generator3")>
        };
    }),
    executor(exec)
};

value exec(gen1(Planning p)) {
    rVal = generator1(p);
    outputFile = |project://rascaldsl/instance/output/generator1.txt|; 
    writeFile(outputFile, rVal);
    edit(outputFile);
    return ("result": true);
}

value exec(gen2(Planning p)) {
    rVal = generator2(p);
    outputFile = |project://rascaldsl/instance/output/generator2.txt|; 
    writeFile(outputFile, rVal);
    edit(outputFile);
    return ("result": true);
}

value exec(gen3(Planning p)) {
    rVal = generator3(p);
    outputFile = |project://rascaldsl/instance/output/generator3.txt|; 
    writeFile(outputFile, rVal);
    edit(outputFile);
    return ("result": true);
}

void main() {
    registerLanguage(tdslLang);
}
