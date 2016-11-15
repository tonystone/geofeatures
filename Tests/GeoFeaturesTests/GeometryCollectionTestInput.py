GeometryClass         = 'GeometryCollection'
GeometryIsGeneric     = False
GeometryElementType   = GeometryClass + '.Element'
ElementCast           = ' as ' + GeometryElementType
ElementArrayCast      = ' as [' + GeometryElementType + ']'

Variants = [
            ('Coordinate2D', 'FloatingPrecision', '()', 'Cartesian', '()',
             # Test Values 1
                'Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], []))',
                'Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], []))',
                'Polygon<Coordinate2D>([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], [])',
             # Test Values 2
                'Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], []))',
                'Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], []))',
                'Polygon<Coordinate2D>([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], [])'),
            
            #    ('Coordinate2DM','FloatingPrecision', '()', 'Cartesian', '()', '(x: 1.0, y: 1.0, m: 1.0)', '(x: 2.0, y: 2.0, m: 2.0)','(x: 1.0, y: 1.0, m: 1.0)', '(x: 2.0, y: 2.0, m: 2.0)'),
            #    ('Coordinate3D', 'FloatingPrecision', '()', 'Cartesian', '()', '(x: 1.0, y: 1.0, z: 1.0)', '(x: 2.0, y: 2.0, z: 2.0)','(x: 1.0, y: 1.0, z: 1.0)', '(x: 2.0, y: 2.0, z: 2.0)'),
            #    ('Coordinate3DM','FloatingPrecision', '()', 'Cartesian', '()', '(x: 1.0, y: 1.0, z: 1.0, m: 1.0)', '(x: 2.0, y: 2.0, z: 2.0, m: 2.0)','(x: 1.0, y: 1.0, z: 1.0, m: 1.0)', '(x: 2.0, y: 2.0, z: 2.0, m: 2.0)'),
            
            #    ('Coordinate2D', 'FixedPrecision', '(scale: 100)', 'Cartesian', '()', '(x: 1.001, y: 1.001)', '(x: 2.002, y: 2.002)','(x: 1.0, y: 1.0)', '(x: 2.0, y: 2.0)'),
            #    ('Coordinate2DM','FixedPrecision', '(scale: 100)', 'Cartesian', '()', '(x: 1.001, y: 1.001, m: 1.001)', '(x: 2.002, y: 2.002, m: 2.002)','(x: 1.0, y: 1.0, m: 1.0)', '(x: 2.0, y: 2.0, m: 2.0)'),
            #    ('Coordinate3D', 'FixedPrecision', '(scale: 100)', 'Cartesian', '()', '(x: 1.001, y: 1.001, z: 1.001)', '(x: 2.002, y: 2.002, z: 2.002)','(x: 1.0, y: 1.0, z: 1.0)', '(x: 2.0, y: 2.0, z: 2.0)'),
            #    ('Coordinate3DM','FixedPrecision', '(scale: 100)', 'Cartesian', '()', '(x: 1.001, y: 1.001, z: 1.001, m: 1.001)', '(x: 2.002, y: 2.002, z: 2.002, m: 2.002)','(x: 1.0, y: 1.0, z: 1.0, m: 1.0)', '(x: 2.0, y: 2.0, z: 2.0, m: 2.0)'),
            ]

