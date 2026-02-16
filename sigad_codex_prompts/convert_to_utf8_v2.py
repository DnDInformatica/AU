#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Script Conversione UTF-8 V2 - Migliorato
Converte file da vari encoding a UTF-8 puro
"""
import os
import sys
import chardet
import shutil
from pathlib import Path
from typing import List, Tuple, Optional

class UTF8ConverterV2:
    """Converte file da vari encoding a UTF-8"""
    
    FALLBACK_ENCODINGS = [
        'utf-16',
        'utf-16-le',
        'utf-16-be',
        'cp1252',
        'iso-8859-1',
        'ascii',
    ]
    
    def __init__(self, source_dir: str, backup: bool = True, recursive: bool = True):
        self.source_dir = Path(source_dir)
        self.backup = backup
        self.recursive = recursive
        self.results = {
            'converted': [],
            'already_utf8': [],
            'errors': [],
            'skipped': [],
            'repaired': []
        }
        
    def detect_encoding(self, file_path: Path) -> Tuple[Optional[str], float]:
        """Rileva l'encoding di un file"""
        try:
            with open(file_path, 'rb') as f:
                raw_data = f.read(100000)
            
            # Controlla BOM
            if raw_data.startswith(b'\xff\xfe\x00\x00'):
                return 'utf-32-le', 1.0
            elif raw_data.startswith(b'\x00\x00\xfe\xff'):
                return 'utf-32-be', 1.0
            elif raw_data.startswith(b'\xff\xfe'):
                return 'utf-16-le', 1.0
            elif raw_data.startswith(b'\xfe\xff'):
                return 'utf-16-be', 1.0
            elif raw_data.startswith(b'\xef\xbb\xbf'):
                return 'utf-8-sig', 1.0
            
            # Usa chardet
            result = chardet.detect(raw_data)
            encoding = result.get('encoding')
            confidence = result.get('confidence', 0)
            
            return encoding, confidence
            
        except Exception as e:
            return None, 0
    
    def try_read_file(self, file_path: Path, encoding: str) -> Optional[str]:
        """Prova a leggere un file con un encoding specifico"""
        try:
            with open(file_path, 'r', encoding=encoding, errors='strict') as f:
                return f.read()
        except:
            try:
                with open(file_path, 'r', encoding=encoding, errors='replace') as f:
                    return f.read()
            except:
                return None
    
    def repair_corrupted_file(self, file_path: Path) -> bool:
        """Ripara file corrotti (virgolette sparse)"""
        try:
            with open(file_path, 'rb') as f:
                content = f.read()
            
            if len(content) > 4 and content[1] == 0x22:
                fixed = bytearray()
                i = 0
                while i < len(content):
                    if content[i] == 0x22 and i + 1 < len(content):
                        fixed.append(content[i + 1])
                        i += 2
                        if i < len(content) and content[i] == 0x22:
                            i += 1
                    else:
                        fixed.append(content[i])
                        i += 1
                
                try:
                    test = fixed.decode('utf-8')
                    if test.strip().startswith('#'):
                        with open(file_path, 'wb') as f:
                            f.write(fixed)
                        return True
                except:
                    pass
            
            return False
        except:
            return False
    
    def convert_file(self, file_path: Path) -> bool:
        """Converte un file singolo a UTF-8"""
        try:
            encoding, confidence = self.detect_encoding(file_path)
            
            if encoding is None:
                content = None
                detected_enc = None
                for enc in self.FALLBACK_ENCODINGS:
                    content = self.try_read_file(file_path, enc)
                    if content is not None:
                        detected_enc = enc
                        break
                
                if content is None:
                    self.results['skipped'].append(f"{file_path.name} (encoding sconosciuto)")
                    return False
            else:
                detected_enc = encoding
                if detected_enc.upper() in ['UTF-8', 'UTF8', 'ASCII']:
                    self.results['already_utf8'].append(file_path.name)
                    if self.repair_corrupted_file(file_path):
                        self.results['repaired'].append(file_path.name)
                    return True
                
                content = self.try_read_file(file_path, detected_enc)
                if content is None:
                    self.results['skipped'].append(f"{file_path.name} (impossibile leggere)")
                    return False
            
            if self.backup:
                backup_path = file_path.with_suffix(file_path.suffix + '.bak')
                if not backup_path.exists():
                    shutil.copy2(file_path, backup_path)
            
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(content)
            
            self.results['converted'].append(f"{file_path.name} (da {detected_enc})")
            return True
            
        except Exception as e:
            self.results['errors'].append(f"{file_path.name}: {str(e)}")
            return False
    
    def convert_directory(self, extensions: List[str] = None) -> None:
        """Converte tutti i file di una directory"""
        
        if not self.source_dir.exists():
            print(f"Directory non trovata: {self.source_dir}")
            return
        
        pattern = '**/*' if self.recursive else '*'
        
        if extensions:
            files = []
            for ext in extensions:
                files.extend(self.source_dir.glob(f'{pattern}{ext}'))
        else:
            files = [f for f in self.source_dir.glob(pattern) if f.is_file()]
        
        print(f"\nTrovati {len(files)} file in '{self.source_dir}'")
        print(f"Conversione in corso...\n")
        
        for idx, file_path in enumerate(files, 1):
            print(f"[{idx}/{len(files)}] {file_path.name}...", end=" ", flush=True)
            
            if self.convert_file(file_path):
                print("OK")
            else:
                print("SKIP")
        
        self.print_report()
    
    def print_report(self) -> None:
        """Stampa un report dei risultati"""
        print("\n" + "="*70)
        print("REPORT CONVERSIONE UTF-8 V2")
        print("="*70)
        print(f"Convertiti:    {len(self.results['converted'])}")
        print(f"Gia UTF-8:     {len(self.results['already_utf8'])}")
        print(f"Riparati:      {len(self.results['repaired'])}")
        print(f"Skipped:       {len(self.results['skipped'])}")
        print(f"Errori:        {len(self.results['errors'])}")
        
        if self.results['converted']:
            print("\nConvertiti:")
            for file in self.results['converted']:
                print(f"  - {file}")
        
        if self.results['already_utf8']:
            print("\nGia UTF-8:")
            for file in self.results['already_utf8'][:5]:
                print(f"  - {file}")
            if len(self.results['already_utf8']) > 5:
                print(f"  ... e altri {len(self.results['already_utf8']) - 5}")
        
        if self.results['repaired']:
            print("\nRiparati:")
            for file in self.results['repaired']:
                print(f"  - {file}")
        
        if self.results['errors']:
            print("\nErrori:")
            for error in self.results['errors']:
                print(f"  - {error}")


if __name__ == "__main__":
    DIRECTORY = "prompts"
    BACKUP = True
    RECURSIVE = False
    EXTENSIONS = ['.txt', '.py', '.sql', '.xml', '.json', '.csv', '.md', '.js', '.html', '.css', '.prompt']
    
    converter = UTF8ConverterV2(
        source_dir=DIRECTORY,
        backup=BACKUP,
        recursive=RECURSIVE
    )
    
    converter.convert_directory(extensions=EXTENSIONS)
