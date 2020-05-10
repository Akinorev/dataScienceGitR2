from lxml import etree
import json
import re

# Functions
def clear_branch(element):
    """Free up memory for temporary element tree after processing the element"""
    while element.getprevious() is not None:
        del element.getparent()[0]

def extractor(branch, features):
    """Extract the value of each feature"""
    attribs = {"id": [branch.attrib["key"]], "branch": [branch.tag]}
    for feature in features:
        attribs[feature] = []
    for sub in branch:
        if sub.tag not in features:
            continue
        if sub.tag == "title":
            text = re.sub("<.*?>", "", etree.tostring(sub).decode("utf-8")) if sub.text is None else sub.text
        elif sub.tag == "pages":
            text = count_pages(sub.text)
        else:
            text = sub.text
        if text is not None and len(text) > 0:
            attribs[sub.tag] = attribs.get(sub.tag) + [text]
    attribs = json.dumps(attribs)
    return attribs

def count_pages(pages):
    cnt = 0
    for part in re.compile(r",").split(pages):
        subparts = re.compile(r"-").split(part)
        if len(subparts) > 2:
            continue
        else:
            try:
                re_digits = re.compile(r"[\d]+")
                subparts = [int(re_digits.findall(sub)[-1]) for sub in subparts]
            except IndexError:
                continue
            cnt += 1 if len(subparts) == 1 else subparts[1] - subparts[0] + 1
    return "" if cnt == 0 else str(cnt)


# all of the element types in dblp
selected_elements = {"article", "inproceedings", "incollection"} # "article" "inproceedings" "incollection"
# all of the feature types in dblp
features = {"author", "booktitle", "editor", "isbn", "pages", "publisher", "title", "year"}


# My code
dblp_path = "dblp.xml"
json_path = "dblp_parsed.json"

f = open(json_path, "w", encoding="utf8")
tree = etree.iterparse(source=dblp_path, dtd_validation=True, load_dtd=True)
counter = 0
for _ , branch in tree:
    if branch.tag in selected_elements:
        if counter%100000 == 0:
            print(counter)
        counter += 1
        attributes = extractor(branch, features)
        f.write(str(attributes) + "\n")
        clear_branch(branch)
f.close()